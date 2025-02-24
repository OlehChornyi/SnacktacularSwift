//
//  Spot.swift
//  SnacktacularSwift
//
//  Created by Oleh on 17.02.2025.
//

import Foundation
import FirebaseFirestore

struct Spot: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
}
