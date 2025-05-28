//
//  LoginView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: (Gradient(colors: [.blue, .orange])), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Welcome to NusNomNom")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    Image("nusLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 150)
                    
                    
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    
                    Button("Login") {
                        login()
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    
                    // Hidden Navigation Trigger
                    NavigationLink(value: "MainView") {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .padding()
                .navigationDestination(isPresented: $isAuthenticated) {
                    MainView()
                }
            }
        }
    }

    func login() {
        if email.lowercased() == "student@nus.edu.sg" && password == "password123" {
            isAuthenticated = true
        }
    }
}



#Preview {
    LoginView()
}
