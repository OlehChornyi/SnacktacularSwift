//
//  SpotDetailView.swift
//  SnacktacularSwift
//
//  Created by Oleh on 17.02.2025.
//

import SwiftUI

struct SpotDetailView: View {
    @State var spot: Spot
    @State private var photoSheetIsPresented = false
    @State private var showingAlert = false
    @State private var alertMessage = "Cannot add a Photo until you save the Spot."
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Group {
                TextField("name", text: $spot.name)
                    .font(.title)
                    .autocorrectionDisabled()
                
                TextField("address", text: $spot.address)
                    .font(.title2)
                    .autocorrectionDisabled()
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            Button {
                if spot.id == nil {
                    showingAlert.toggle()
                } else {
                    photoSheetIsPresented.toggle()
                }
            } label: {
                Image(systemName: "camera.fill")
                Text("Photo")
            }
            .bold()
            .buttonStyle(.borderedProminent)
            .tint(.snack)

            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveSpot()
                    dismiss()
                }
            }
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                Task {
                    guard let id = await SpotViewModel.saveSpot(spot: spot) else { return }
                    spot.id = id
                    photoSheetIsPresented.toggle()
                }
            }
        }
        .fullScreenCover(isPresented: $photoSheetIsPresented) {
            PhotoView(spot: spot)
        }
    }
    
    func saveSpot() {
        Task {
            guard let id = await SpotViewModel.saveSpot(spot: spot) else {return}
        }
    }
}

#Preview {
    NavigationStack {
        SpotDetailView(spot: Spot())
    }
}
