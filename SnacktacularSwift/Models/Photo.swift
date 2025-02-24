//
//  Photo.swift
//  SnacktacularSwift
//
//  Created by Oleh on 24.02.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class Photo: Identifiable, Codable {
    @DocumentID var id: String?
    var imageUrlString = ""
    var descritption = ""
    var reviewer: String = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    init(id: String? = nil, imageUrlString: String = "", descritption: String = "", reviewer: String = "", postedOn: Date = Date()) {
        self.id = id
        self.imageUrlString = imageUrlString
        self.descritption = descritption
        self.reviewer = reviewer
        self.postedOn = postedOn
    }
}

extension Photo {
    static var preview: Photo {
        let newPhoto = Photo(
            id: "1",
            imageUrlString: "",
            descritption: "",
            reviewer: "",
            postedOn: Date()
        )
        return newPhoto
    }
}
