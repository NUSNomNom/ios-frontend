//
//  CardComponents.swift
//  NUSNomNom
//
//  Created by Nutabi on 25/7/25.
//

import SwiftUI

struct LocationCard: View {
    let location: Location
    
    var body: some View {
        VStack {
            RemoteImage(image_url: location.imageUrl)
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

struct StoreCard: View {
    let store: Store
    let locationName: String?
    
    init(store: Store, locationName: String? = nil) {
        self.store = store
        self.locationName = locationName
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RemoteImage(image_url: store.imageUrl)
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(12)
            
            Text(store.name)
                .foregroundColor(.black)
                .font(.headline)
                .lineLimit(1)
            
            if let locationName = locationName {
                Text(locationName)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

struct ItemCard: View {
    let item: Item
    
    var body: some View {
        HStack {
            RemoteImage(image_url: item.imageUrl)
                .scaledToFill()
                .frame(width: 40, height: 40)
                .padding(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(item.information)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                Text(item.isAvailable ? "Available" : "Sold Out")
                    .font(.caption)
                    .foregroundColor(item.isAvailable ? .green : .red)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
