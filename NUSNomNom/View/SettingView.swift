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
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Profile")
                            .font(.system(size: 25))
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 4)
                        

                        if auth.isLoggedIn {
                            VStack(alignment: .leading, spacing: 12) {

                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .center)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("auth.displayName")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .frame(maxWidth: .infinity, alignment: .center)

                                        Text("auth.email")
                                            .font(.subheadline)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .foregroundColor(.gray)
                                    }

                                Button("Sign Out") {
                                    auth.logout()
                                }
                                .foregroundStyle(.red)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .cornerRadius(12)
                            }
                            
                        } else {
                        
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Text("Sign in!")
                                .font(.system(size: 30))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Text("Sign in to start reviewing your favourite store!")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                                
                            
                            Button("Sign in with email") {
                                isShowingLogin = true
                            }
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            
                        }
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Data")
                            .font(.headline)
                            .padding(.bottom, 4)

                        Button("Refresh") {
                            Task {
                                do {
                                    try await data.refresh()
                                } catch {
                                    refreshErrorMessage = error.localizedDescription
                                    showRefreshErrorAlert = true
                                }
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .fontWeight(.bold)
                        .cornerRadius(12)
                        
                        Text("Last Updated: \(data.getLastUpdated())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
        }
        .sheet(isPresented: $isShowingLogin) {
            LoginView(loginSuccess: $showLoginSuccessAlert)
                .environmentObject(auth)
        }
        .alert("Successful Login", isPresented: $showLoginSuccessAlert) {
            Button("OK", role: .cancel) {}
        }
        .alert("Error", isPresented: $showRefreshErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(refreshErrorMessage)
        }
    }
}

#Preview {
    SettingView()
        .environmentObject(AuthManager.shared)
        .environmentObject(DataManager.shared)
}
