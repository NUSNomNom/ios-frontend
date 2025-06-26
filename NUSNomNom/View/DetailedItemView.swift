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
        
        Image("nusNomNomLongLogo")
            .resizable()
            .scaledToFit()
            .frame(height: 100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 25)
        
        ScrollView {
            
            Image(systemName: "photo")
                .resizable()
                .foregroundColor(.blue)
                .scaledToFill()
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .clipped()
            
            VStack(alignment: .leading, spacing: 10) {
                Text(item.name)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.nusBlue)
                    .lineLimit(1)
                
                Text(item.information)
                    .font(.headline)
                    .foregroundColor(.black)
                
                HStack {
                    Text("Price:")
                        .font(.subheadline)
                    
                    
                    Text(String(format: "$%.2f", item.price.doubleValue))
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                
                HStack {
                    Text("Availability:")
                        .font(.subheadline)
                    
                    Text(item.is_available ? "Available" : "Sold Out")
                        .font(.subheadline)
                        .foregroundColor(item.is_available ? .green : .red)
                }
                
            }
            Spacer()
        }
    }
}

#Preview {
    let mockItem = Item(
        id: 1,
        name: "Fried Rice",
        price: .init(wrapperValue: Decimal(string: "5.00") ?? 0),
        is_available: true,
        information: "Classic egg fried rice with vegetables and soy sauce."
    )

    NavigationStack {
        DetailedItemView(item: mockItem)
    }
}
