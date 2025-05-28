//
//  SettingView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var isShowingLogin = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account")) {
                    if isLoggedIn {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text("placeholder name")
                                    .font(.headline)
                                Text("student@u.nus.edu")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Button("Logout") {
                            isLoggedIn = false
                        }
                        .foregroundColor(.red)
                    } else {
                        Button("Login") {
                            isShowingLogin = true
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $isShowingLogin) {
                LoginView()
            }
        }
    }
}


#Preview {
    SettingView()
}
