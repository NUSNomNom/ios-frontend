//
//  DetailedStoreView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI

struct DetailedStoreView: View {
    
    var store:Store
    @Binding var isShowingDetailedView: Bool
    
    var body: some View {
        
        VStack (spacing: 20) {
            
            Spacer()
            
            Text(store.name)
                .font(.title)
                .fontWeight(.bold)
            
            Text(store.description)
                .font(.title2)
                .fontWeight(.medium)
                .padding()
            
            Text("placeholder for menu")
                .font(.title2)
                .fontWeight(.medium)
                .padding()
            
            Spacer()
        }
    }
}

#Preview {
    DetailedStoreView(store: MockStoreData.sampleStore, isShowingDetailedView: .constant(false))
}
