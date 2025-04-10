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
    
    func createCafeDocument(cafe: Cafe) {
        do {
            try db.collection("cafes")
                .document(cafe.uid)
                .setData(from: cafe)
        } catch {
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
