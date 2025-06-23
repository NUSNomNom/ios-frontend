//
//  SettingView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var auth: AuthManager
    @EnvironmentObject private var data: DataManager
    
    @State private var isShowingLogin = false
    
    @State private var showLoginSuccessAlert = false
    @State private var showRefreshErrorAlert = false
    
    @State private var refreshErrorMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account")) {
                    if auth.isLoggedIn {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .center, spacing: 12) {
                                Image(systemName: "person.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(.blue)
                                
                                VStack(alignment: .leading) {
                                    Text(auth.displayName)
                                        .font(.headline)
                                    
                                    Text(auth.email)
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                }
                            }
                            
                            Divider()
                            
                            Button("Sign Out") {
                                auth.logout()
                            }
                            .foregroundStyle(.red)
                        }
                    } else {
                        Button("Sign In to Review") {
                            isShowingLogin = true
                        }
                    }
                }
                
                Section(header: Text("Data")) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Last Updated: \(data.getLastUpdated())")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Divider()
                        
                        Button("Refresh") {
                            Task {
                                do {
                                    try await data.refresh()
                                } catch {
                                    showRefreshErrorAlert = true
                                    refreshErrorMessage = error.localizedDescription
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .sheet(isPresented: $isShowingLogin) {
            LoginView(loginSuccess: $showLoginSuccessAlert)
                .environmentObject(auth)
        }
        .alert(
            "Successful Login",
            isPresented: $showLoginSuccessAlert
        ) {
            Button("OK", role: .cancel) {}
        }
        .alert(
            "Error",
            isPresented: $showRefreshErrorAlert
        ) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text(refreshErrorMessage)
        }
    }
}
