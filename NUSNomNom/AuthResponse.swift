//
//  AuthResponse.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 30/5/25.
//

import Foundation

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

