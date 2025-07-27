//
//  StoreReviewsView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 10/7/25.
//

import SwiftUI

struct StoreReviewsView: View {
    let store: Store
    @EnvironmentObject private var auth: AuthManager
    @EnvironmentObject private var data: DataManager
    @State private var isShowingLogin = false
    @State private var showReviewSheet = false
    @State private var showLoginSuccessAlert = false
    @State private var reviews: [Review] = []
    @State private var isLoadingReviews = true
    @State private var usernames: [Int: String] = [:]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerSection
            
            reviewsContent
            
            actionButton
        }
        .padding()
        .onAppear {
            Task {
                await loadReviews()
            }
        }
        .sheet(isPresented: $showReviewSheet) {
            LeaveReviewView(store: store)
        }
        .sheet(isPresented: $isShowingLogin) {
            LoginView(loginSuccess: $showLoginSuccessAlert)
                .environmentObject(auth)
        }
        .alert("Login Successful", isPresented: $showLoginSuccessAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Reviews for \(store.name)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.nusBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)

            Text("⭐️ \(String(format: "%.1f", averageRating)) · Based on \(reviews.count) review\(reviews.count == 1 ? "" : "s")")
                .font(.title3)

            Divider()
        }
    }
    
    private var reviewsContent: some View {
        Group {
            if isLoadingReviews {
                LoadingView(message: "Loading reviews...")
            } else if reviews.isEmpty {
                EmptyStateView(
                    title: "No reviews yet",
                    subtitle: "Be the first to leave a review!",
                    systemImage: "star"
                )
            } else {
                reviewsList
            }
        }
    }
    
    private var reviewsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(reviews) { review in
                ReviewCard(
                    author: usernames[review.nomerId] ?? "Loading...",
                    content: review.comment,
                    rating: review.score,
                    createdAt: review.createdAt
                )
            }
        }
    }
    
    private var actionButton: some View {
        Group {
            if auth.isLoggedIn {
                NUSBlueButton(title: "Leave a Review") {
                    showReviewSheet = true
                }
                .padding(.top)
            } else {
                NUSOrangeButton(title: "Login to Leave a Review") {
                    isShowingLogin = true
                }
            }
        }
    }
    
    private var averageRating: Double {
        guard !reviews.isEmpty else { return 0 }
        let total = reviews.reduce(0) { $0 + $1.score }
        return Double(total) / Double(reviews.count)
    }
    
    private func loadReviews() async {
        isLoadingReviews = true
        
        do {
            let fetchedReviews = try await data.getReviews(of: store.id)
            reviews = fetchedReviews
            
            for review in reviews {
                if usernames[review.nomerId] == nil {
                    do {
                        let username = try await data.getPublicUsername(of: review.nomerId)
                        usernames[review.nomerId] = username
                    } catch {
                        usernames[review.nomerId] = "Anonymous"
                    }
                }
            }
        } catch {
            print("Failed to load reviews: \(error)")
            reviews = []
        }
        
        isLoadingReviews = false
    }
}

#Preview {
    let mockItem = Item(
        id: 1,
        name: "Fried Rice",
        price: .init(wrapperValue: Decimal(string: "5.00") ?? 0),
        isAvailable: true,
        information: "Classic egg fried rice with vegetables.",
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

    StoreReviewsView(store: mockStore)
        .environmentObject(AuthManager.shared)
        .environmentObject(DataManager.shared)
}
