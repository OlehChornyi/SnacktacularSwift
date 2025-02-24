//
//  StarsSelectionView.swift
//  SnacktacularSwift
//
//  Created by Oleh on 25.02.2025.
//

import SwiftUI

struct StarsSelectionView: View {
    @Binding var rating: Int
    let highestRating = 5
    let unselected = Image(systemName: "star")
    let selected = Image(systemName: "star.fill")
    let font: Font = .largeTitle
    let fillColor: Color = .red
    let emptyColor: Color = .gray
    
    var body: some View {
        HStack{
            ForEach(1...highestRating, id: \.self) { number in
                showStar(for: number)
                    .foregroundStyle(number <= rating ? fillColor : emptyColor)
                    .onTapGesture {
                        rating = number
                    }
            }
            .font(font)
        }
    }
    func showStar( for number: Int) -> Image {
        if number > rating {
            return unselected
        } else {
            return selected
        }
    }
}

#Preview {
    StarsSelectionView(rating: .constant(4))
}
