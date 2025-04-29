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
    
    var cafeStatusCache: [String: String] = [:] // store previous status
    
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
        print("Sending notification...")
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "MyNotifcation", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            }
        }
    }
    
    
    func listenForStatusChange(favorites: [String]) {
        print("listenForStatusChange")
        let db = Firestore.firestore()
        
        print("FAVORITE CAFE IDS:")
        for cafeId in favorites {
            print("   \(cafeId)")
            db.collection("cafes").document(cafeId).addSnapshotListener { documentSnapshot, error in
                guard let doc = documentSnapshot, doc.exists,
                      let data = doc.data(),
                      let newStatus = data["status"] as? String
            else {
                return
            }

                if let oldStatus = self.cafeStatusCache[cafeId], oldStatus == newStatus {
                    return
                }
                self.cafeStatusCache[cafeId] = newStatus
                
                self.sendNotification(title: "\(data["name"] as? String ?? "Favorites") Status Update!", body: "\(newStatus)")
            }
        }
    }
}

