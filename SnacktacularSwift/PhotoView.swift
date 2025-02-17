//
//  PhotoView.swift
//  SnacktacularSwift
//
//  Created by Oleh on 17.02.2025.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
    @State var spot: Spot
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pickerIsPresented = true
    @State private var selectedImage = Image(systemName: "photo")
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            selectedImage
                .resizable()
                .scaledToFit()
            
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            //TODO
                            dismiss()
                        }
                    }
                }
                .photosPicker(isPresented: $pickerIsPresented, selection: $selectedPhoto)
                .onChange(of: selectedPhoto) {
                    //turn selectedPhoto into a usable imageView
                    Task {
                        do {
                            if let image = try await selectedPhoto?.loadTransferable(type: Image.self) {
                                selectedImage = image }
                        } catch {
                            print("ERROR: Could not create Image from selectedPhoto. \(error.localizedDescription)")
                        }
                    }
                }
        }
        .padding()
    }
}

#Preview {
    PhotoView(spot: Spot())
}
