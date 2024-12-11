//
//  File.swift
//  
//
//  Created by Bora Erdem on 5.02.2024.
//

import Foundation
import Defaults
import StoreKit

public protocol RatingAlertProtocol {
    var title: String {get}
    var description: String {get}
    var action1Title: String {get}
    var action2Title: String {get}
}

public final class RatingManager {
    private static var askCount = 0

    public static func showNativeRating() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }
    
    public static func increaseLikeCountAndShowRatePopup(for alert: RatingAlertProtocol) {
        if self.ratingPromptCounterLogic() {
            RatingManager.askCount += 1
            self.prepareCustomRatePopup(for: alert)
        } else {
            showNativeRating()
        }
    }
    
    private static func prepareCustomRatePopup(for alert: RatingAlertProtocol) {
        AlertManager.show(
            title: alert.title,
            message: alert.description,
            action1Title: alert.action1Title,
            action1Handler: { _ in
            },
            action2Title: alert.action2Title,
            action2Handler: { _ in
                Defaults[.isLikedBefore] = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showNativeRating()
                }
            }
        )
    }

    private static func ratingPromptCounterLogic() -> Bool {
        if Defaults[.isLikedBefore] {
            if !Defaults[.isBonusRatingSeen] {
                Defaults[.isBonusRatingSeen] = true
                return true
            } else {
                return false
            }
        }
        
        if RatingManager.askCount > 1 {
            return false
        } else {
            return true
        }
    }
    
}
