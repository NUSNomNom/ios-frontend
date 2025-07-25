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
                    headerSection
                    
                    ratingSection
                    
                    reviewSection
                    
                    submitButton
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
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            CancelNavigationHeader {
                dismiss()
            }
            
            PageTitle(
                title: "Leave a Review for \(store.name)",
                alignment: .center
            )
        }
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Rating")
                .font(.headline)

            RatingStars(rating: $rating)
        }
    }
    
    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Review")
                .font(.headline)

            StyledTextEditor(
                text: $content,
                placeholder: "Enter your review here..."
            )
        }
    }
    
    private var submitButton: some View {
        NUSBlueButton(
            title: "Submit Review",
            isDisabled: !isFormValid,
            isLoading: isSubmitting
        ) {
            submitReview()
        }
    }
    
    private var isFormValid: Bool {
        !content.trimmingCharacters(in: .whitespaces).isEmpty && rating > 0
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
