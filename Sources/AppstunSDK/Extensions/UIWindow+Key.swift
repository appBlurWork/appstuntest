//
//  File.swift
//  
//
//  Created by Bora Erdem on 5.02.2024.
//

import UIKit

@available(iOS 13.0, tvOS 13.0, *)
public extension UIWindow {
    static var keyWindow: UIWindow? {
        let keyWindow = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive }
            .flatMap { $0 as? UIWindowScene }?.windows
            .first { $0.isKeyWindow }
        return keyWindow
    }
}

@available(iOS 13.0, tvOS 13.0, *)
public func topViewController() -> UIViewController? {
    let keyWindow = UIWindow.keyWindow
    if var topController = keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    return nil
}
