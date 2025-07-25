//
//  NUSLogoHeader.swift
//  NUSNomNom
//
//  Created by Nutabi on 25/7/25.
//

import SwiftUI

struct NUSLogoHeader: View {
    var body: some View {
        Image("nusNomNomLongLogo")
            .resizable()
            .scaledToFit()
            .frame(height: 100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 25)
    }
}

#Preview {
    NUSLogoHeader()
}
