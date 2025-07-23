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
    let is_open: Bool
    let cuisine: String
    let information: String
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
        return "Mock Name"
    }
    
    func getReviews(of storeId: Int) async throws -> [Review] {
        // Get reviews from GET /api/review/
        return []
    }
    
    func submitReview(for storeId: Int, by nomerAccessToken: String, score: Int, comment: String) async throws {
        // Create review at POST /api/review
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
            
            guard let locations = try? JSONDecoder().decode([Location].self, from: data) else {
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
        if let data = try? JSONEncoder().encode(cache) {
            try? data.write(to: url)
        }
    }
    
    private func load() {
        let url = getDirectory().appendingPathComponent("cache.json")
        if let data = try? Data(contentsOf: url),
           let cache = try? JSONDecoder().decode(Cache.self, from: data) {
            self.lastUpdated = cache.date
            self.locations = cache.locations
        } else {
            Task {
                try? await refresh()
            }
        }
    }
}
