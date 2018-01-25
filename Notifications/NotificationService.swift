//
//  NotificationService.swift
//  Notifications
//
//  Created by Ezequiel Becerra on 24/01/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        func save(_ identifier: String, data: Data, options: [AnyHashable: Any]?) -> UNNotificationAttachment? {
            
            var directory = URL(fileURLWithPath: NSTemporaryDirectory())
            directory = directory.appendingPathComponent(
                ProcessInfo.processInfo.globallyUniqueString,
                isDirectory: true)
            
            do {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
                
                let fileURL = directory.appendingPathComponent(identifier)
                try data.write(to: fileURL, options: [])
                return try UNNotificationAttachment.init(identifier: identifier, url: fileURL, options: options)
            } catch {
                //  Do nothing
            }
            return nil
        }
        
        func exitGracefully(_ reason: String = "") {
            let bca = request.content.mutableCopy() as? UNMutableNotificationContent
            bca!.title = reason
            contentHandler(bca!)
        }
        
        guard let content = (request.content.mutableCopy() as? UNMutableNotificationContent) else {
            return exitGracefully()
        }
        
        let userInfo: [AnyHashable: Any] = request.content.userInfo
        
        guard let attachmentURL = userInfo["media-url"] as? String else {
            return exitGracefully()
        }
        
        guard let imageData  =
            try? Data(contentsOf: URL(string: attachmentURL)!)
            else {
                return exitGracefully()
        }
        
        guard let attachment =
            save("image.png", data: imageData, options: nil)
            else {
                return exitGracefully()
        }
        
        content.attachments = [attachment]
        contentHandler(content.copy() as! UNNotificationContent)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
