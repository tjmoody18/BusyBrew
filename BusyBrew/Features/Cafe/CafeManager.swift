//
//  CafeManager.swift
//  BusyBrew
//
//  Created by Thomas Moody on 4/8/25.
//

import Foundation

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class CafeManager {
    
    static let shared = CafeManager()
    private let db = Firestore.firestore()
    private let documentPath = "cafes"
    
    func createCafeDocument(uid: String, email: String) {
        let newCafe = Cafe.empty(uid: uid, name: email)
        
        do {
            try db.collection("cafes").document(uid).setData(from : newCafe)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func updateDocument(uid: String, data: [String: Any]) {
        db.collection("cafes").document(uid).updateData(data)
    }
    
    func fetchCafeDocument(uid: String) async -> Cafe? {
        do {
            let cafeDocument = try await db.collection("cafes").document(uid).getDocument(as: Cafe.self)
            print("Fetched and decoded cafe: \(cafeDocument)")
            return cafeDocument
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
