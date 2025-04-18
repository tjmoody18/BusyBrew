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
    
    func createUserDocument(uid: String, email: String) {
        
        let newUser = User.empty(uid: uid, email: email)
        
        do {
            try db.collection("users").document(uid).setData(from: newUser)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func updateDocument(uid: String, data: [String: Any]) {
        db.collection("users").document(uid).updateData(data)
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
    
    /// ** EXAMPLE CALL for fetchUserDocument() :
//    Task {
//        if let user = await UserManager().fetchUserDocument() {
//            print("User found: \(user)")
//        } else {
//            print("Failed to fetch user data")
//        }
//    }    
    
}
