//
//  RatingStars.swift
//  NUSNomNom
//
//  Created by Nutabi on 25/7/25.
//

import SwiftUI

struct RatingStars: View {
    @Binding var rating: Int
    let isInteractive: Bool
    let starSize: CGFloat
    
    init(
        rating: Binding<Int>,
        isInteractive: Bool = true,
        starSize: CGFloat = 28
    ) {
        self._rating = rating
        self.isInteractive = isInteractive
        self.starSize = starSize
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1..<6) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .resizable()
                    .frame(width: starSize, height: starSize)
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        if isInteractive {
                            rating = star
                        }
                    }
            }
        }
    }
}

struct DisplayRatingStars: View {
    let rating: Int
    let starSize: CGFloat
    
    init(rating: Int, starSize: CGFloat = 16) {
        self.rating = rating
        self.starSize = starSize
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1..<6) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .resizable()
                    .frame(width: starSize, height: starSize)
                    .foregroundColor(.yellow)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        VStack {
            Text("Interactive Rating")
            RatingStars(rating: .constant(3))
        }
        
        VStack {
            Text("Display Only")
            DisplayRatingStars(rating: 4)
        }
        
        VStack {
            Text("Small Display")
            DisplayRatingStars(rating: 5, starSize: 12)
        }
    }
    .padding()
}
