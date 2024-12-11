//
//  File.swift
//  
//
//  Created by Bora Erdem on 5.02.2024.
//

import Foundation
import Defaults
import Qonversion

public enum RevenueProcessResult {
    case premium, normal, failure(Error)
}

public protocol ProductTypeProtocol: Hashable {
    var id: String {get}
}

public struct OfferPruduct {
    public var type: any ProductTypeProtocol
    public var id: String
    public var product: Qonversion.Product?
    
    public init(type: any ProductTypeProtocol, id: String, product: Qonversion.Product? = nil) {
        self.type = type
        self.id = id
        self.product = product
    }
}

public final class RevenueManager: NSObject {
    
    public static func initializeQonversion(with id: String, products: [OfferPruduct]) {
        self.products = products
        Qonversion.initWithConfig(.init(projectKey: id, launchMode: .subscriptionManagement))
    }
    
    override init() {
        super.init()
        Qonversion.shared().setEntitlementsUpdateListener(self)
    }
        
    static private var products: [OfferPruduct] = []
    static private var isPackagesFetched = false
    static public var updateUI: (()->())?
    
    public static func fetchProdutcs() {
        
        Qonversion.shared().products {  productList, err in
            
            if err != nil {
                return
            }
            
            for i in 0..<products.count {
                var tmpProduct = products[i]
                tmpProduct.product = productList[tmpProduct.id]
                self.products[i] = tmpProduct
            }
            
            isPackagesFetched = true
            checkEntitlements()
            updateUI?()
        }
    }
    
    public static func getPackage(for type: any ProductTypeProtocol) -> Qonversion.Product? {
        guard isPackagesFetched else {return nil}
        return products.first(where: {$0.id == type.id})?.product
    }
    
    public static func checkEntitlements() {
        Qonversion.shared().checkEntitlements { (entitlements, error) in
            if let _ = error {
                return
            }
            
            if let premium: Qonversion.Entitlement = entitlements["pro"], premium.isActive {
                switch premium.renewState {
                case .willRenew, .nonRenewable:
                    // .willRenew is the state of an auto-renewable subscription
                    // .nonRenewable is the state of consumable/non-consumable IAPs that could unlock lifetime access
                    break
                case .billingIssue:
                    // Grace period: entitlement is active, but there was some billing issue.
                    // Prompt the user to update the payment method.
                    break
                case .cancelled:
                    // The user has turned off auto-renewal for the subscription, but the subscription has not expired yet.
                    // Prompt the user to resubscribe with a special offer.
                    break
                default: break
                }
                
                Defaults[.premium] = true
                return
            }
            
            Defaults[.premium] = false
            return
        }
    }
    
    public static func restorePurchases(completion: @escaping (RevenueProcessResult)->()) {
        Qonversion.shared().restore { (entitlements, error) in
            if error != nil {
                completion(.failure(error!))
                return
            }
            
            if let entitlement: Qonversion.Entitlement = entitlements["pro"], entitlement.isActive {
                Defaults[.premium] = true
                completion(.premium)
                return
            }
            
            Defaults[.premium] = false
            completion(.normal)
        }
    }
    
    public static func purchasePackage(for type: any ProductTypeProtocol, completion: @escaping (RevenueProcessResult)->()) {
        
        guard let product = getPackage(for: type) else {
            completion(.failure(NSError(domain: "com.appstun", code: 0)))
            return
        }
        
        Qonversion.shared().purchaseProduct(product) { (entitlements, error, isCancelled) in
            if let premium: Qonversion.Entitlement = entitlements["pro"], premium.isActive {
                Defaults[.premium] = true
                completion(.premium)
                return
            }
            
            completion(.normal)
            return
        }
    }
    
}

extension RevenueManager: Qonversion.EntitlementsUpdateListener {
    public func didReceiveUpdatedEntitlements(_ entitlements: [String : Qonversion.Entitlement]) {
        if let premium: Qonversion.Entitlement = entitlements["pro"], premium.isActive {
            Defaults[.premium] = true
        } else {
            Defaults[.premium] = false
        }
    }
}

