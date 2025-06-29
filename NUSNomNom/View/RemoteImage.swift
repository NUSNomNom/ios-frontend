//
//  RemoteImage.swift
//  NUSNomNom
//
//  Created by Nutabi on 29/6/25.
//

import SwiftUI

struct RemoteImage: View {
    var image_url: URL
    
    var body: some View {
        AsyncImage(url: image_url) { phase in
            switch phase {
            case .success(let image):
                image.resizable()
            case .empty:
                ProgressView()
            default:
                Image(systemName: "photo").resizable()
            }
        }
    }
}
