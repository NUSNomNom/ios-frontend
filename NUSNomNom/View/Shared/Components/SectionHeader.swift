//
//  SectionHeader.swift
//  NUSNomNom
//
//  Created by Nutabi on 25/7/25.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let color: Color
    let fontSize: CGFloat
    
    init(
        title: String,
        color: Color = .nusBlue,
        fontSize: CGFloat = 24
    ) {
        self.title = title
        self.color = color
        self.fontSize = fontSize
    }
    
    var body: some View {
        Text(title)
            .font(.system(size: fontSize, weight: .bold))
            .foregroundColor(color)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SectionTitle: View {
    let title: String
    let color: Color
    
    init(
        title: String,
        color: Color = .nusBlue
    ) {
        self.title = title
        self.color = color
    }
    
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(color)
    }
}

// MARK: - Previews
#Preview {
    VStack(spacing: 16) {
        SectionHeader(title: "Information")
        SectionTitle(title: "Stores")
        SectionHeader(title: "Reviews", color: .orange, fontSize: 20)
    }
    .padding()
}
