//
//  DataManager.swift
//  NUSNomNom
//
//  Created by Nutabi on 19/6/25.
//

import Foundation

struct GetAllLocationResponseItem: Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
}

struct GetOneLocationResponseItem: Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let stores: [StoreNoItems]
}

struct StoreNoItems: Codable {
    let id: Int
    let name: String
    let isOpen: Bool
    let cuisine: String
    let information: String
}

struct GetPublicUserResponseItem: Codable {
    let id: Int
    let displayName: String
}

struct SubmitReviewRequestBody: Codable {
    let storeId: Int
    let score: Int
    let comment: String
}

enum DataError: Error {
    case badConfiguration
    case networkIssue(underlying: Error)
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingFailed
}

extension DataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badConfiguration:
            return "Invalid app configuration"
        case .networkIssue(underlying: let error):
            return "Network issue: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid server response"
        case .httpError(statusCode: let code):
            return "HTTP error: \(code)"
        case .decodingFailed:
            return "Failed to decode data"
        }
    }
}

struct Cache: Codable {
    let date: Date?
    let locations: [Location]
}

@MainActor
final class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var locations: [Location] = []

    private var lastUpdated: Date?
    
    private init() {
        load()
    }
    
    func refresh() async throws {
        try await fetch()
        lastUpdated = Date()
        save()
    }
    
    func getLastUpdated() -> String {
        guard let date = lastUpdated else { return "Never" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func getPublicUsername(of userId: Int) async throws -> String {
        // Get user display name from GET /api/user/{userId}
        guard let apiUrl = Bundle.main.infoDictionary?["API_URL"] as? String,
              let url = URL(string: "\(apiUrl)/api/user/\(userId)")
        else {
            throw DataError.badConfiguration
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw DataError.invalidResponse
            }
            
            switch response.statusCode {
            case 200..<300:
                break
            default:
                throw DataError.httpError(statusCode: response.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            guard let user = try? decoder.decode(GetPublicUserResponseItem.self, from: data) else {
                throw DataError.decodingFailed
            }
            
            return user.displayName
            
        } catch let error as URLError {
            throw DataError.networkIssue(underlying: error)
        } catch {
            throw error
        }
    }
    
    func getReviews(of storeId: Int) async throws -> [Review] {
        // Get reviews from GET /api/review/
        guard let apiUrl = Bundle.main.infoDictionary?["API_URL"] as? String,
              let url = URL(string: "\(apiUrl)/api/review?store_id=\(storeId)")
        else {
            throw DataError.badConfiguration
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw DataError.invalidResponse
            }
            
            switch response.statusCode {
            case 200..<300:
                break
            default:
                throw DataError.httpError(statusCode: response.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            guard let reviews = try? decoder.decode([Review].self, from: data) else {
                throw DataError.decodingFailed
            }
            
            return reviews
            
        } catch let error as URLError {
            throw DataError.networkIssue(underlying: error)
        } catch {
            throw error
        }
    }
    
    func submitReview(for storeId: Int, by nomerAccessToken: String, score: Int, comment: String) async throws {
        // Create review at POST /api/review
        guard let apiUrl = Bundle.main.infoDictionary?["API_URL"] as? String,
              let url = URL(string: "\(apiUrl)/api/review")
        else {
            throw DataError.badConfiguration
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(nomerAccessToken, forHTTPHeaderField: "X-Api-Key")
        
        let body = SubmitReviewRequestBody(storeId: storeId, score: score, comment: comment)
        request.httpBody = try? JSONEncoder().encode(body)
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw DataError.invalidResponse
            }
            
            switch response.statusCode {
            case 200..<300:
                break
            default:
                throw DataError.httpError(statusCode: response.statusCode)
            }
        } catch let error as URLError {
            throw DataError.networkIssue(underlying: error)
        } catch {
            throw error
        }
    }
    
    private func fetch() async throws {
        guard let apiUrl = Bundle.main.infoDictionary?["API_URL"] as? String,
              let url = URL(string: "\(apiUrl)/api/data")
        else {
            throw DataError.badConfiguration
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw DataError.invalidResponse
            }
            
            switch response.statusCode {
            case 200..<300:
                break
            default:
                throw DataError.httpError(statusCode: response.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            guard let locations = try? decoder.decode([Location].self, from: data) else {
                throw DataError.decodingFailed
            }
            
            self.locations = locations
            
        } catch let error as URLError {
            throw DataError.networkIssue(underlying: error)
        } catch {
            throw error
        }
    }
    
    private func getDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func save() {
        let url = getDirectory().appendingPathComponent("cache.json")
        let cache = Cache(date: lastUpdated, locations: locations)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(cache) {
            try? data.write(to: url)
        }
    }
    
    private func load() {
        let url = getDirectory().appendingPathComponent("cache.json")
        if let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let cache = try? decoder.decode(Cache.self, from: data) {
                self.lastUpdated = cache.date
                self.locations = cache.locations
            } else {
                Task {
                    try? await refresh()
                }
            }
        } else {
            Task {
                try? await refresh()
            }
        }
    }
}
