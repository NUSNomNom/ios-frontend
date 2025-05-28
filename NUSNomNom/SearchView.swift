//
//  SearchView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI

struct SearchView: View {
    @State private var dummySearchText: String = ""
    @State private var showFilters = false
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        
        VStack {
            
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search food stalls...", text: $dummySearchText)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Button {
                    showFilters.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .padding(10)
            }
            .padding()
            
            NavigationStack {
                List(MockStoreData.stores) {
                    store in
                    
                    NavigationLink(destination: DetailedStoreView(store: store, isShowingDetailedView: $viewModel.isShowingDetailedView)) {
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(store.name)
                                    .font(.headline)
                                Spacer()
                                Text(store.isOpen ? "Open" : "Closed")
                                    .font(.caption)
                                    .foregroundColor(store.isOpen ? .green : .red)
                            }
                            
                            Text(store.cuisine)
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                            
                            Text(store.description)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(3)
                        }
                        .padding(.vertical, 4)
                    }
                    .navigationTitle("All Food Stalls")
                }
            }
        }
    }
}
#Preview {
    SearchView()
}
