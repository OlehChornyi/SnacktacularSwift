//
//  PhotoViewModel.swift
//  SnacktacularSwift
//
//  Created by Oleh on 24.02.2025.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI

class PhotoViewModel {
    static func savePhoto(spot: Spot, photo: Photo, data: Data) async {
        guard let id = spot.id else {return}
        
        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        if photo.id == nil {
            photo.id = UUID().uuidString
        }
        metadata.contentType = "image/jpeg"
        let path = "\(id)/\(photo.id ?? "n/a")"
        
        do {
            let storageRef = storage.child(path)
            let returnedMetadata = try await storageRef.putDataAsync(data, metadata: metadata)
            print("😎 SAVED! \(returnedMetadata)")
            
            guard let url = try? await storageRef.downloadURL() else {
                print("🤬ERROR: Could not get download url")
                return
            }
            
            photo.imageUrlString = url.absoluteString
            
            let db = Firestore.firestore()
            do {
                try db.collection("spots").document(id).collection("photos").document(photo.id ?? "n/a").setData(from: photo)
            } catch {
                print("🤬ERROR: Could not update data in spots/ \(id)/photos/\(photo.id ?? "n/a"). \(error.localizedDescription)")
            }
        } catch {
            print("🤬ERROR saving photo to storage: \(error.localizedDescription)")
        }
    }
}
