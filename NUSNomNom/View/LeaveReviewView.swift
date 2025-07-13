//
//  LeaveReviewView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 10/7/25.
//

import SwiftUI

struct LeaveReviewView: View {
    let store: Store

    @Environment(\.dismiss) private var dismiss
    @State private var rating: Int = 0
    @State private var content: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Spacer()
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .padding(.trailing)
                    }
                    .padding(.bottom, 40)
                    
                    Text("Leave a Review for \(store.name)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.nusBlue)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Rating")
                            .font(.headline)

                        HStack(spacing: 8) {
                            ForEach(1..<6) { star in
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.yellow)
                                    .onTapGesture {
                                        rating = star
                                    }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Review")
                            .font(.headline)

                        ZStack(alignment: .topLeading) {
                            if content.isEmpty {
                                Text("Enter your review here...")
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                            }

                            TextEditor(text: $content)
                                .frame(height: 120)
                                .padding(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3))
                                )
                        }
                    }

                    Button("Submit Review") {
                        // Submit review to backend
                        dismiss()
                    }
                    .disabled(content.trimmingCharacters(in: .whitespaces).isEmpty || rating == 0)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((content.trimmingCharacters(in: .whitespaces).isEmpty || rating == 0) ? Color.gray : .nusBlue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .fontWeight(.bold)
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

#Preview {
    let mockItem = Item(
        id: 1,
        name: "Laksa",
        price: .init(wrapperValue: Decimal(string: "4.50") ?? 0),
        is_available: true,
        information: "Spicy noodle soup with prawns and tofu.",
        image_url: URL(string: "https://nomnom-image.sgp1.cdn.digitaloceanspaces.com/item_chinese_1.jpeg")!
    )

    let mockStore = Store(
        id: 1,
        name: "Golden Wok",
        is_open: true,
        cuisine: "Chinese",
        information: "Wok-fried Chinese specialties",
        image_url: URL(string: "https://nomnom-image.sgp1.cdn.digitaloceanspaces.com/store_chinese.jpeg")!,
        items: [mockItem]
    )

    return LeaveReviewView(store: mockStore)
}
