//
//  Review.swift
//  SnacktacularSwift
//
//  Created by Oleh on 25.02.2025.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct Review: Identifiable, Codable {
    @DocumentID var id: String?
    var title = ""
    var body = ""
    var rating = 0
    var reviewer = ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["title": title, "body": body, "rating": rating, "reviewer": Auth.auth().currentUser?.email ?? "", "postedOn": Timestamp(date: Date())]
    }
}
