//
//  Cart.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/2/26.
//

import Foundation

struct CartItem: Identifiable, Codable {
    let id: UUID
    let title: String
    let price: Double
    let imageURL: String
    var quantity: Int
    
    init(id: UUID = UUID(), title: String, price: Double, imageURL: String, quantity: Int) {
        self.id = id
        self.title = title
        self.price = price
        self.imageURL = imageURL
        self.quantity = quantity
    }

    var formattedPrice: String {
        String(format: "₱%.2f", price)
    }
}
