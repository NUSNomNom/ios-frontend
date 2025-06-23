//
//  AllView.swift
//  NUSNomNom
//
//  Created by Nutabi on 21/6/25.
//

import SwiftUI

struct AllView: View {
    @EnvironmentObject private var data: DataManager
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(data.locations) { location in
                        NavigationLink {
                            DetailedLocationView(location: location)
                        } label: {
                            VStack {
                                // Mock image
                                // Future API will provide image (somehow)
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipped()
                                    .cornerRadius(12)
                                Text(location.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.top, 4)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(radius: 4)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Locations")
        }
    }
}
