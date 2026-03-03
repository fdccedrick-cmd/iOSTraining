//
//  FavoriteItem.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/3/26.
//

import Foundation

struct FavoriteItem: Identifiable , Codable {
    var id: UUID = UUID()
    let title: String
    let price: Double
    let imageURL: String
    let category: String
    let rating: Double

    var formattedPrice: String {
        String(format: "₱%.2f", price)
    }
    var formattedRating: String{
        String(format: "₱%.2f", price)
    }
    
}
