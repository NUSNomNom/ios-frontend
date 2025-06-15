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

    @AppStorage("accessToken") var accessToken: String = ""
    @AppStorage("refreshToken") var refreshToken: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("userName") var userName: String = ""
    @AppStorage("userEmail") var userEmail: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
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
        guard let url = URL(string: "http://68.183.235.200:3000/api/session") else {
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

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "Login failed or invalid server response"
                }
                return
            }

            do {
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                DispatchQueue.main.async {
                    self.accessToken = authResponse.accessToken
                    self.refreshToken = authResponse.refreshToken
                    self.isLoggedIn = true
                    self.fetchUserDetails()
                    self.dismiss()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse response"
                }
            }
        }.resume()
    }

    func fetchUserDetails() {
        guard let url = URL(string: "http://68.183.235.200:3000/api/user") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(accessToken)", forHTTPHeaderField: "X-Api-Key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let user = try? JSONDecoder().decode(UserResponse.self, from: data) else {
                return
            }

            DispatchQueue.main.async {
                self.userName = user.displayName
                self.userEmail = user.email
            }
        }.resume()
    }
}

struct UserResponse: Decodable {
    let id: Int
    let displayName: String
    let email: String
}



#Preview {
    LoginView()
}
