//
//  MockData.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import Foundation
import MapKit

struct Store: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let isOpen: BooleanLiteralType
    let cuisine: String
    let description: String
    let location: String
}

struct MockStoreData {
    
    static let sampleStore = Store(
        name: "Liang Ban Gong Fu",
        isOpen: true,
        cuisine: "Chinese",
        description: "Affordable Chinese-style rice bowls with generous portions, known for their fast service and variety of proteins.",
        location: "The Deck")
    
    static let stores = [
        Store(
            name: "Liang Ban Gong Fu",
            isOpen: true,
            cuisine: "Chinese",
            description: "Affordable Chinese-style rice bowls with generous portions, known for their fast service and variety of proteins.",
            location: "The Deck"),
        Store(
            name: "Noodles Stall",
            isOpen: true,
            cuisine: "Chinese",
            description: "Pick-your-own ingredients with a light broth or dry sauce, perfect for healthy eaters and customisation lovers.",
            location: "Techno Edge"),
        Store(name: "The Rice Bowl", isOpen: true, cuisine: "Asian Fusion", description: "Offers a mix of Japanese, Korean, and Chinese-style rice bowls, popular for its crispy chicken and spicy sauces.", location: "Flavours @ UTown"),
        Store(name: "Mala Xiang Guo", isOpen: true, cuisine: "Sichuan", description: "Customisable spice bowls with a punchy, numbing flavour. Choose your own ingredients and spice level.", location: "PGPR Canteen"),
        Store(name: "Deck Western", isOpen: false, cuisine: "Western", description: "Classic Western fare like chicken chop, fish & chips, and pasta at student-friendly prices.", location: "The Deck"),
        Store(name: "Indian Cuisine", isOpen: true, cuisine: "Indian", description: "Aromatic curries, biryani, and prata options served hot with rich spices and generous portions.", location: "The Terrace"),
        Store(name: "Duck Rice", isOpen: false, cuisine: "Chinese", description: "Tender braised duck served with yam rice or white rice, accompanied by herbal soup and chilli.", location: "Frontier"),
        Store(name: "Japanese Bento", isOpen: true, cuisine: "Japanese", description: "Affordable bentos with teriyaki chicken, salmon, and tempura. Comes with miso soup.", location: "Flavours @ UTown"),
        Store(name: "Korean Cuisine", isOpen: true, cuisine: "Korean", description: "Bibimbap, spicy chicken, kimchi stew and more. Comfort food for K-food lovers.", location: "Techno Edge"),
        Store(name: "Salad Bar", isOpen: true, cuisine: "Healthy", description: "Customisable salads with a range of toppings and dressings. Light and refreshing meals.", location: "Frontier")
    ]
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

let nusLocations: [Location] = [
    Location(name: "The Deck", coordinate: CLLocationCoordinate2D(latitude: 1.2966, longitude: 103.7764)),
    Location(name: "Techno Edge", coordinate: CLLocationCoordinate2D(latitude: 1.2961, longitude: 103.7732)),
    Location(name: "UTown Food Clique", coordinate: CLLocationCoordinate2D(latitude: 1.3050, longitude: 103.7722)),
    Location(name: "Frontier", coordinate: CLLocationCoordinate2D(latitude: 1.2972, longitude: 103.7801))
]

