//
//  SearchViewModel.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI

final class SearchViewModel: ObservableObject {
    var selectedStore: Store? {
        didSet{
            isShowingDetailedView.toggle()
        }
    }
    
    @Published var isShowingDetailedView = false
}
