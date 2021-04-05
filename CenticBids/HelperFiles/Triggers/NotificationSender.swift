//
//  NotificationSender.swift
//  CenticBids
//
//  Created by Pruthvi Nithyanandan on 2021-04-02.
//

import Foundation
import UserNotifications

class NotificationSender: NSObject {
    
    //  method to send local notification
    func sendNotification(title: String, subtitle: String, body: String){
        let content = UNMutableNotificationContent()
        // local notification content
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "LatestbidAmtNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
        
}

extension NotificationSender: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
}
