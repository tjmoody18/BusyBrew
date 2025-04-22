//
//  UserManager.swift
//  BusyBrew
//
//  Created by Thomas Moody on 4/8/25.
//

import Foundation

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class UserManager {
    
    static let shared = UserManager()
    private let db = Firestore.firestore()
    private let documentPath = "users"
    
    func createUserDocument(uid: String, email: String, displayName: String) {
        let userData: [String: Any] = [
            "uid": uid,
            "email": email,
            "displayName": displayName,
            "photoUrl": "",
            "favorites": [],
            "friends": []
            
        ]
        
        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Error creating user document: \(error.localizedDescription)")
            } else {
                print("User document created successfully.")
            }
        }
    }

    
    func updateDocument(uid: String, data: [String: Any]) {
        db.collection("users").document(uid).updateData(data)
    }
    
    func fetchUserDocument(uid: String) async -> User? {
        do {
            let userDocument = try await db.collection("users").document(uid).getDocument(as: User.self)
            print("Fetched and decoded User: \(userDocument)")
            return userDocument
        }
        catch {
            print("Error fetching user document: \(error.localizedDescription)")
            return nil
        }
    }
    
    func addFavorite(uid: String, data: String) {
        db.collection("users").document(uid).updateData(["favorites" : FieldValue.arrayUnion([data])])
    }
    
    func deleteFavorite(uid: String, data: String) {
        db.collection("users").document(uid).updateData(["favorites" : FieldValue.arrayRemove([data])])
    }
    
    func fetchUserDocument() async -> User? {
        guard let user = Auth.auth().currentUser else { return nil }
        
        do {
            let userDocument = try await db.collection("users").document(user.uid).getDocument(as: User.self)
            print("Fetched and decoded User: \(userDocument)")
            return userDocument
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
