//
//  ReviewCard.swift
//  NUSNomNom
//
//  Created by Nutabi on 25/7/25.
//

import SwiftUI

struct ReviewCard: View {
    let author: String
    let content: String
    let rating: Int
    let createdAt: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(author)
                    .font(.headline)
                    .foregroundColor(.nusBlue)
                
                Spacer()
                
                Text(createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            DisplayRatingStars(rating: rating, starSize: 12)

            Text(content)
                .font(.body)
                .foregroundColor(.black)

            Divider()
        }
    }
}

#Preview {
    ReviewCard(
        author: "John Doe",
        content: "Great food and excellent service! Highly recommend the fried rice.",
        rating: 4,
        createdAt: Date()
    )
    .padding()
}
