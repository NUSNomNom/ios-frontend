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
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss

    
    @AppStorage("accessToken") private var accessToken: String = ""
    @AppStorage("refreshToken") private var refreshToken: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

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
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("Don't have an account? Register")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(12)
                    }
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }

    func login() {
            guard let url = URL(string: "http://209.38.57.6/api/session") else {
                errorMessage = "Invalid backend URL"
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: String] = [
                "email": email,
                "password": password
            ]
            request.httpBody = try? JSONEncoder().encode(body)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Network error: \(error.localizedDescription)"
                    }
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Invalid server response"
                    }
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Login failed: \(httpResponse.statusCode)"
                    }
                    return
                }

                guard let data = data else {
                    DispatchQueue.main.async {
                        self.errorMessage = "No data received"
                    }
                    return
                }

                do {
                    let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.accessToken = authResponse.accessToken
                        self.refreshToken = authResponse.refreshToken
                        self.isLoggedIn = true
                        self.dismiss()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse response"
                    }
                }

            }.resume()
        }
}



#Preview {
    LoginView()
}
