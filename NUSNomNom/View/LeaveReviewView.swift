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
    @State private var isSubmitting: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var dataManager = DataManager.shared

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
                        submitReview()
                    }
                    .disabled(content.trimmingCharacters(in: .whitespaces).isEmpty || rating == 0 || isSubmitting)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((content.trimmingCharacters(in: .whitespaces).isEmpty || rating == 0 || isSubmitting) ? Color.gray : .nusBlue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .fontWeight(.bold)
                    .overlay(
                        Group {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                        }
                    )
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Review Submission", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func submitReview() {
        guard let accessToken = authManager.accessToken else {
            alertMessage = "You must be logged in to submit a review"
            showAlert = true
            return
        }
        
        isSubmitting = true
        
        Task {
            do {
                try await dataManager.submitReview(
                    for: store.id,
                    by: accessToken,
                    score: rating,
                    comment: content.trimmingCharacters(in: .whitespaces)
                )
                
                await MainActor.run {
                    isSubmitting = false
                    alertMessage = "Review submitted successfully!"
                    showAlert = true
                    
                    // Dismiss after showing success message
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    alertMessage = "Failed to submit review: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    let mockItem = Item(
        id: 1,
        name: "Laksa",
        price: .init(wrapperValue: Decimal(string: "4.50") ?? 0),
        isAvailable: true,
        information: "Spicy noodle soup with prawns and tofu.",
        imageUrl: URL(string: "https://nomnom-image.sgp1.cdn.digitaloceanspaces.com/item_chinese_1.jpeg")!
    )

    let mockStore = Store(
        id: 1,
        name: "Golden Wok",
        isOpen: true,
        cuisine: "Chinese",
        information: "Wok-fried Chinese specialties",
        imageUrl: URL(string: "https://nomnom-image.sgp1.cdn.digitaloceanspaces.com/store_chinese.jpeg")!,
        items: [mockItem]
    )

    return LeaveReviewView(store: mockStore)
}
