//
//  AuthManager.swift
//  NUSNomNom
//
//  Created by Nutabi on 16/6/25.
//

import Foundation

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

struct UserInfoResponse: Codable {
    let displayName: String
    let email: String
}

enum AuthError: Error {
    case badConfiguration
    case validationFailed
    case encodingFailed
    case networkIssue(underlying: Error)
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingFailed
    case failedAuthentication
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badConfiguration:
            return "Invalid app configuration"
        case .validationFailed:
            return "Validation failed"
        case .encodingFailed:
            return "Failed to encode data"
        case .networkIssue(underlying: let error):
            return "Network issue: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid server response"
        case .httpError(statusCode: let code):
            return "HTTP error: \(code)"
        case .decodingFailed:
            return "Failed to decode data"
        case .failedAuthentication:
            return "Wrong email or password"
        }
    }
}

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published private(set) var isLoggedIn = false
    @Published private(set) var displayName = ""
    @Published private(set) var email = ""
    
    private(set) var accessToken: String?
    private(set) var refreshToken: String?
    
    private init() {
        loadTokens()
        Task {
            do {
                try await fetchUserInfo()
            } catch {
                // Any failure, assume not login
                // Logout to reset
                logout()
            }
        }
    }
    
    func register(displayName: String, email: String, password: String) async throws {
        if !checkPassword(password) {
            throw AuthError.validationFailed
        }
        
        guard let apiUrl = Bundle.main.infoDictionary?["API_URL"] as? String,
              let url = URL(string: "\(apiUrl)/api/user")
        else {
            throw AuthError.badConfiguration
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["displayName": displayName, "email": email, "password": password]
        if let body = try? JSONEncoder().encode(body) {
            request.httpBody = body
        } else {
            throw AuthError.encodingFailed
        }
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw AuthError.invalidResponse
            }
            
            switch response.statusCode {
            case 200..<300:
                break
            default:
                throw AuthError.httpError(statusCode: response.statusCode)
            }
            
        } catch let error as URLError {
            throw AuthError.networkIssue(underlying: error)
        } catch {
            throw error
        }
    }
    
    func login(as email: String, with password: String) async throws {
        guard let apiUrl = Bundle.main.infoDictionary?["API_URL"] as? String,
              let url = URL(string: "\(apiUrl)/api/session")
        else {
            throw AuthError.badConfiguration
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "password": password]
        if let body = try? JSONEncoder().encode(body) {
            request.httpBody = body
        } else {
            throw AuthError.encodingFailed
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw AuthError.invalidResponse
            }
            
            switch response.statusCode {
            case 200..<300:
                break
            case 401:
                throw AuthError.failedAuthentication
            default:
                throw AuthError.httpError(statusCode: response.statusCode)
            }
            
            do {
                let tokens = try JSONDecoder().decode(LoginResponse.self, from: data)
                try saveToken(key: "accessToken", value: tokens.accessToken)
                try saveToken(key: "refreshToken", value: tokens.refreshToken)
                
                accessToken = tokens.accessToken
                refreshToken = tokens.refreshToken
                isLoggedIn = true
                
                try await fetchUserInfo()
            } catch {
                throw AuthError.decodingFailed
            }
            
        } catch let error as URLError {
            throw AuthError.networkIssue(underlying: error)
        } catch {
            throw error
        }
    }
    
    func logout() {
        // Since authentication is token-based, we simply delete the tokens from Keychain
        deleteToken(key: "accessToken")
        deleteToken(key: "refreshToken")
        
        accessToken = nil
        refreshToken = nil
        isLoggedIn = false
    }
    
    private func checkPassword(_ password: String) -> Bool {
        // Placeholder for password checker
        return true
    }
    
    private func fetchUserInfo() async throws {
        guard let apiUrl = Bundle.main.infoDictionary?["API_URL"] as? String,
              let url = URL(string: "\(apiUrl)/api/user")
        else {
            throw AuthError.badConfiguration
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = accessToken {
            request.allHTTPHeaderFields = ["X-Api-Key": token]
        } else {
            throw AuthError.badConfiguration
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw AuthError.invalidResponse
            }
            
            switch response.statusCode {
            case 200..<300:
                break
            default:
                throw AuthError.httpError(statusCode: response.statusCode)
            }
            
            guard let info = try? JSONDecoder().decode(UserInfoResponse.self, from: data) else {
                throw AuthError.decodingFailed
            }
            
            displayName = info.displayName
            email = info.email
            
        } catch let error as URLError {
            throw AuthError.networkIssue(underlying: error)
        } catch {
            throw error
        }
    }
    
    private func loadTokens() {
        if let access = try? loadToken(key: "accessToken"),
           let refresh = try? loadToken(key: "refreshToken") {
            accessToken = access
            refreshToken = refresh
            isLoggedIn = true
        }
    }
    
    private func loadToken(key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess,
           let data = item as? Data,
           let value = String(data: data, encoding: .utf8) {
            return value
        } else {
            return nil
        }
    }
    
    private func saveToken(key: String, value: String) throws {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete existing tokens with the same tag
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: nil)
        }
    }
    
    private func deleteToken(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(query as CFDictionary)
    }
}
