//
//  ReviewViewModel.swift
//  SnacktacularSwift
//
//  Created by Oleh on 25.02.2025.
//

import Foundation
import FirebaseFirestore

@Observable
class ReviewViewModel {
    
    static func saveReview(spot: Spot, review: Review) async -> String? {
        let db = Firestore.firestore()
        
        let collectionString = "spots/\(spot.id ?? "")/reviews"
        
        if let id = review.id {
            do {
                try db.collection(collectionString).document(id).setData(from: review)
                print("Data updated successfully!")
                return id
            } catch {
                print("Could not update data in 'reviews' collection \(error.localizedDescription)")
                return id
            }
        } else {
            do {
                let docRef = try db.collection(collectionString).addDocument(from: review)
                print("Data added successfully!")
                return docRef.documentID
            } catch {
                print("Could not create a new review in 'reviews' collection \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    static func deleteSpot(spot: Spot) {
        let db = Firestore.firestore()
        guard let id = spot.id else {return}
        
        Task {
            do {
                try await db.collection("spots").document(id).delete()
            } catch {
                print("ERROR: Could not delete a document \(id) \(error.localizedDescription)")
            }
        }
    }
}
