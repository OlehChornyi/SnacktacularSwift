//
//  ReviewView.swift
//  SnacktacularSwift
//
//  Created by Oleh on 25.02.2025.
//

import SwiftUI

struct ReviewView: View {
    @State var spot: Spot
    @State var review: Review
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            VStack (alignment: .leading){
                Text(spot.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Text(spot.address)
                    .padding(.bottom)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Click to rate")
                .font(.title2)
                .bold()
            HStack {
                StarsSelectionView(rating: $review.rating)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            .padding(.bottom)
            
            VStack (alignment: .leading) {
                Text("Review Title:")
                    .bold()
                
                TextField("title", text: $review.title)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                
                Text("Review:")
                    .bold()
                
                TextField("review", text: $review.body, axis: .vertical)
                    .padding(.horizontal, 6)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            .padding(.horizontal)
            .font(.title2)
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    Task {
                        await ReviewViewModel.saveReview(spot: spot, review: review)
                    }
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ReviewView(spot: Spot(name: "Shake Shack", address: "49 Boyleston Street"), review: Review())
    }
}
