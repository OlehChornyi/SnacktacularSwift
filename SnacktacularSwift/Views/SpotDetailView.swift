//
//  SpotDetailView.swift
//  SnacktacularSwift
//
//  Created by Oleh on 17.02.2025.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct SpotDetailView: View {
    @FirestoreQuery(collectionPath: "spots") var photos: [Photo]
    @FirestoreQuery(collectionPath: "spots") var reviews: [Review]
    @State var spot: Spot
    @State private var photoSheetIsPresented = false
    @State private var showReviewViewSheet = false
    @State private var showingAlert = false
    @State private var showSaveAlert = false
    @State private var showingAsSheet = false
    @State private var alertMessage = "Cannot add a Photo until you save the Spot."
    @Environment(\.dismiss) private var dismiss
    var previewRunning = false
    
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

            ScrollView(.horizontal) {
                HStack{
                    ForEach(photos) { photo in
                        let url = URL(string: photo.imageUrlString)
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }

                    }
                }
            }
            .frame(height: 80)
            
            List {
                Section {
                    ForEach(reviews) { review in
                        NavigationLink {
                            ReviewView(spot: spot, review: review)
                        } label: {
                            Text(review.title)
                        }

                    }
                } header: {
                    HStack{
                        Text("Avg.rating:")
                            .font(.title2)
                            .bold()
                        Text("4.5")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundStyle(Color("SnackColor"))
                        Spacer()
                        Button("Rate It") {
                            if spot.id == nil {
                                showSaveAlert.toggle()
                            } else {
                                showReviewViewSheet.toggle()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .bold()
                        .tint(Color("SnackColor"))
                    }
                }
                .headerProminence(.increased)
            }
            .listStyle(.plain)
            
            Spacer()
        }
        .onAppear {
            if !previewRunning && spot.id != nil {
                $reviews.path = "spots/\(spot.id ?? "")/reviews"
            } else {
                showingAsSheet = true
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            if spot.id != nil {
                $photos.path = "spots/\(spot.id ?? "")/photos"
            }
        }
        
        .toolbar {
            if showingAsSheet {
                
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
            } else if showingAsSheet && spot.id != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
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
        .alert("Cannot Rate the Place Unless It is Saved", isPresented: $showSaveAlert, actions: {
            Button("Cancel", role: .cancel) {}
            Button("Save", role: .none) {
                Task {
                    let success = await SpotViewModel.saveSpot(spot: spot)
                    if success != nil {
                        $reviews.path = "spots/\(spot.id ?? "")/reviews"
                        showReviewViewSheet.toggle()
                    } else {
                        print("🤬 Dang! Error saving spot!")
                    }
                }
            }
        }, message: {
            Text("Would you like to save this allert first?")
        })
        .fullScreenCover(isPresented: $photoSheetIsPresented) {
            PhotoView(spot: spot)
        }
        .sheet(isPresented: $showReviewViewSheet) {
            NavigationStack {
                ReviewView(spot: spot, review: Review())
            }
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
        SpotDetailView(spot: Spot(id: "1", name: "Something new", address: "Ukraine"))
    }
}
