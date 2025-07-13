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
    @State private var isShowingLogin = false
    @State private var showReviewSheet = false
    @State private var showLoginSuccessAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reviews for \(store.name)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.nusBlue)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("⭐️ 4.5 · Based on 28 reviews")
                .font(.title3)

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                ReviewCard(author: "Alice", content: "Great variety and quick service!", rating: 5)
                ReviewCard(author: "Bob", content: "Affordable and tasty. Would come again.", rating: 4)
                ReviewCard(author: "Chen Wei", content: "Slightly long wait during lunch.", rating: 3)
            }

            if auth.isLoggedIn {
                Button(action: {
                    showReviewSheet = true
                }) {
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("Leave a Review")
                    }
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.nusBlue)
                    .cornerRadius(12)
                }
                .padding(.top)
            } else {
                Button("Login to Leave a Review") {
                    isShowingLogin = true
                }
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.nusOrange)
                .cornerRadius(12)
            }
        }
        .padding()
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
}

struct ReviewCard: View {
    let author: String
    let content: String
    let rating: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(author)
                    .font(.headline)

                HStack(spacing: 2) {
                    ForEach(0..<rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
            }

            Text(content)
                .font(.body)
                .foregroundColor(.secondary)

            Divider()
        }
    }
}

#Preview {
    let mockItem = Item(
        id: 1,
        name: "Fried Rice",
        price: .init(wrapperValue: Decimal(string: "5.00") ?? 0),
        is_available: true,
        information: "Classic egg fried rice with vegetables.",
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

    StoreReviewsView(store: mockStore)
        .environmentObject(AuthManager.shared)
}
