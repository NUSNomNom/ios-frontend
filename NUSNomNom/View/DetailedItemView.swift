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
                Image("nusNomNomLongLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                
                RemoteImage(image_url: item.image_url)
                    .foregroundColor(.blue)
                    .scaledToFit()
                    .frame(height: 290)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(item.name)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.nusBlue)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text(item.information)
                        .font(.headline)
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("Price:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(String(format: "$%.2f", item.price.doubleValue))
                            .font(.subheadline)
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("Availability:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(item.is_available ? "Available" : "Sold Out")
                            .font(.subheadline)
                            .foregroundColor(item.is_available ? .green : .red)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview {
    let mockItem = Item(
        id: 1,
        name: "Fried Rice",
        price: .init(wrapperValue: Decimal(string: "5.00") ?? 0),
        is_available: true,
        information: "Classic egg fried rice with vegetables and soy sauce.",
        image_url: URL(string: "https://nomnom-image.sgp1.cdn.digitaloceanspaces.com/item_chinese_1.jpeg")!
    )

    NavigationStack {
        DetailedItemView(item: mockItem)
    }
}
