//
//  DetailedItemView.swift
//  NUSNomNom
//
//  Created by Nutabi on 22/6/25.
//

import SwiftUI

struct DetailedItemView: View {
    let item: Item

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                
                itemDetailsSection
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            NUSLogoHeader()
            
            RemoteImage(image_url: item.imageUrl)
                .foregroundColor(.blue)
                .scaledToFit()
                .frame(height: 290)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(12)
        }
    }
    
    private var itemDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            PageTitle(
                title: item.name,
                alignment: .leading
            )
            .lineLimit(1)
            .truncationMode(.tail)
            
            Text(item.information)
                .font(.headline)
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
            
            priceInfo
            
            availabilityInfo
        }
    }
    
    private var priceInfo: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Price:")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(String(format: "$%.2f", item.price.doubleValue))
                .font(.subheadline)
        }
    }
    
    private var availabilityInfo: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Availability:")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(item.isAvailable ? "Available" : "Sold Out")
                .font(.subheadline)
                .foregroundColor(item.isAvailable ? .green : .red)
        }
    }
}

#Preview {
    let mockItem = Item(
        id: 1,
        name: "Fried Rice",
        price: .init(wrapperValue: Decimal(string: "5.00") ?? 0),
        isAvailable: true,
        information: "Classic egg fried rice with vegetables and soy sauce.",
        imageUrl: URL(string: "https://nomnom-image.sgp1.cdn.digitaloceanspaces.com/item_chinese_1.jpeg")!
    )

    NavigationStack {
        DetailedItemView(item: mockItem)
    }
}
