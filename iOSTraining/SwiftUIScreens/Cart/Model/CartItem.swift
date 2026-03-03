//
//  Cart.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/2/26.
//

import Foundation

struct CartItem: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let price: Double
    let imageURL: String
    var quantity: Int
    var isSelected: Bool = false
    
    var formattedPrice: String {
        String(format: "₱%.2f", price)
    }
}
