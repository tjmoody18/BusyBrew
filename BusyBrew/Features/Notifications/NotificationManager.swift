//
//  NotifcationManager.swift
//  BusyBrew
//
//  Created by Thomas Moody on 4/22/25.
//

import Foundation
import UserNotifications
import FirebaseFirestore

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Permission granted")
            } else if let error = error {
                print("Error requesting permission: \(error)")
            }
        }
    }
    
    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = body
        content.sound = .default
        
        
        let request = UNNotificationRequest(identifier: "MyNotifcation", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            }
        }
    }
}

