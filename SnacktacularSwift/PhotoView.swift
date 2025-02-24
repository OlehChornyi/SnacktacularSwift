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
    @State private var photo = Photo()
    @State private var data = Data()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pickerIsPresented = true
    @State private var selectedImage = Image(systemName: "photo")
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Spacer()
            
            selectedImage
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            TextField("description", text: $photo.descritption)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("by: \(photo.reviewer), on \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
            
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            Task {
                                await PhotoViewModel.savePhoto(spot: spot, photo: photo, data: data)
                                dismiss()
                            }
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
                            
                            guard let transferredData = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                                print("🤬ERROR: Could not convert data from selectedPhoto")
                                return
                            }
                            data = transferredData
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
