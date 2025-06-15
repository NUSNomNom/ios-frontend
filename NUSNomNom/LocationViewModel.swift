//
//  LocationViewModel.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 15/6/25.
//

import Foundation

class LocationViewModel: ObservableObject {
    @Published var nusLocations: [NUSLocation] = []
    @Published var isLoading = false
    @Published var error: String?

    func fetchLocations() {
        guard let url = URL(string: "http://209.38.56.240:3000/api/location") else {
            self.error = "Invalid URL"
            return
        }

        isLoading = true

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.error = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.error = "No data"
                    return
                }

                do {
                    self.nusLocations = try JSONDecoder().decode([NUSLocation].self, from: data)
                } catch {
                    self.error = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

