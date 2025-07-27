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
                    profileSection
                    dataSection
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
    
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            profileTitle
            
            if auth.isLoggedIn {
                loggedInProfile
            } else {
                loggedOutProfile
            }
        }
    }
    
    private var profileTitle: some View {
        Text("Profile")
            .font(.system(size: 25))
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 4)
    }
    
    private var loggedInProfile: some View {
        VStack(alignment: .leading, spacing: 12) {
            profileIcon
            
            userInfo
            
            NUSOrangeButton(title: "Sign Out") {
                auth.logout()
            }
        }
    }
    
    private var loggedOutProfile: some View {
        VStack(spacing: 16) {
            profileIcon
            
            signInPrompt
            
            PrimaryButton(title: "Sign in with email") {
                isShowingLogin = true
            }
        }
    }
    
    private var profileIcon: some View {
        Image(systemName: "person.crop.circle.fill")
            .font(.system(size: 80))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var userInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(auth.displayName)
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(auth.email)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.gray)
        }
    }
    
    private var signInPrompt: some View {
        VStack(spacing: 8) {
            Text("Sign in!")
                .font(.system(size: 30))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Sign in to start reviewing your favourite store!")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private var dataSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Data")
                .font(.headline)
                .padding(.bottom, 4)
            
            refreshButton
            
            Text("Last Updated: \(data.getLastUpdated())")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var refreshButton: some View {
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
    }
}

#Preview {
    SettingView()
        .environmentObject(AuthManager.shared)
        .environmentObject(DataManager.shared)
}
