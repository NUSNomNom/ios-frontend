//
//  StateViews.swift
//  NUSNomNom
//
//  Created by Nutabi on 25/7/25.
//

import SwiftUI

struct LoadingView: View {
    let message: String
    
    init(message: String = "Loading...") {
        self.message = message
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                Text(message)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
    }
}

struct EmptyStateView: View {
    let title: String
    let subtitle: String?
    let systemImage: String?
    
    init(
        title: String,
        subtitle: String? = nil,
        systemImage: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}

// MARK: - Previews
#Preview("Loading View") {
    LoadingView(message: "Loading reviews...")
}

#Preview("Empty State") {
    EmptyStateView(
        title: "No reviews yet",
        subtitle: "Be the first to leave a review!",
        systemImage: "star"
    )
}
