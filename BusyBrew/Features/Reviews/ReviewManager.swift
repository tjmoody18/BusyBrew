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

class ReviewManager {
    
    static let shared = ReviewManager()
    private let db = Firestore.firestore()
    private let documentPath = "reviews"
    
    func createReviewDocument(forCafeId cafeId: String, review: Review) {
        do {
            try db.collection("cafes")
                .document(cafeId)
                .collection("reviews")
                .addDocument(from: review)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateDocument(forCafeId cafeId: String, reviewId: String, data: [String: Any]) {
        db.collection("cafes").document(cafeId).collection("reviews")
            .document(reviewId).updateData(data)
    }
    
    // fetch single review
    func fetchReview(forCafeId cafeId: String, reviewId: String) async -> Review? {
        do {
            let reviewDocument = try await db.collection("cafes")
                .document(cafeId)
                .collection("reviews")
                .document(reviewId)
                .getDocument(as: Review.self)
            print("Fetched and decoded cafe: \(reviewDocument)")
            return reviewDocument
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchAllReviews(forCafeId cafeId: String) async -> [Review] {
            do {
                let snapshot = try await db.collection("cafes")
                                           .document(cafeId)
                                           .collection("reviews")
                                           .order(by: "date", descending: true)
                                           .getDocuments()
                return snapshot.documents.compactMap { try? $0.data(as: Review.self) }
            } catch {
                print("Error fetching reviews: \(error.localizedDescription)")
                return []
            }
        }
}
