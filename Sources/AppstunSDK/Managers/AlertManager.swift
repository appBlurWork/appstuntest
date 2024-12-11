//
//  File.swift
//  
//
//  Created by Bora Erdem on 5.02.2024.
//

import UIKit

@available(iOS 13.0, tvOS 13.0, *)
public final class AlertManager {
    public static func show(
        title: String?,
        message: String?,
        action1Title: String,
        action1Style: UIAlertAction.Style = .default,
        action1Handler: ((UIAlertAction) -> Void)? = nil,
        action2Title: String,
        action2Style: UIAlertAction.Style = .default,
        action2Handler: ((UIAlertAction) -> Void)? = nil,
        hasOneAction: Bool = false,
        extras: ((UIAlertController)->())? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: action1Title, style: action1Style, handler: action1Handler)
        
        let action2 = UIAlertAction(title: action2Title, style: action2Style, handler: action2Handler)
        
        alertController.addAction(action1)
        if !hasOneAction {
            alertController.addAction(action2)
            alertController.preferredAction = action2
        }

        extras?(alertController)
        
        DispatchQueue.main.async {
            topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
}
