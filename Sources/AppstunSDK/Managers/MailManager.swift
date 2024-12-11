//
//  File.swift
//  
//
//  Created by Bora Erdem on 5.02.2024.
//

import MessageUI
import UIKit

@available(iOS 13.0, tvOS 13.0, *)
public final class MailHelper {
    public static var mailTo: String = "support@appstun.com"
    
    public static func createEmailUrl(to: String, subject: String, body: String) -> URL? {
         let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
         let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

         let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
         let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
         let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
         let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
         let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

         if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
             return gmailUrl
         } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
             return outlookUrl
         } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
             return yahooMail
         } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
             return sparkUrl
         }

         return defaultUrl
     }
    
    public static func presentSupportMailComposer() {
        
        let device = UIDevice.current
        let iOSVersion = device.systemVersion
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        guard let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? Bundle.main.infoDictionary?["CFBundleName"] as? String else {return}
        let userID = UIDevice.current.identifierForVendor?.uuidString
        
        let recipientEmail = mailTo
        let subject = "Feedback for \(appName)"
        let body = """
                Hi, I want to contact you about the app \(appName).
                
                
                ——
                Please don’t delete the info below. It will help us to help you faster and better.
                
                iOS Version: \(iOSVersion)
                Device Name: \(device.name)
                App Version: \(appVersion ?? "")
                User Language: "en"
                User ID: \(userID ?? "")
                """
        let composer = MFMailComposeViewController()
        composer.setToRecipients([recipientEmail])
        composer.setSubject(subject)
        composer.setMessageBody(body, isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            composer.modalPresentationStyle = .formSheet
            composer.modalTransitionStyle = .coverVertical
            topViewController()?.present(composer, animated: true)
            return
        } else {
            if let mail = createEmailUrl(to: mailTo, subject: "", body: "") {
                UIApplication.shared.open(mail)
            }
        }
        
    }
}
