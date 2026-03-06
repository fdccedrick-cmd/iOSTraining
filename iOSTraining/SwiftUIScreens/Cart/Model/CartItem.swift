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
    var isFlashSale: Bool = false
    var originalPrice: Double?
    var productId: Int? 
    
    var formattedPrice: String {
        String(format: "₱%.2f", price)
    }
    
    var formattedOriginalPrice: String? {
        guard let original = originalPrice else { return nil }
        return String(format: "₱%.2f", original)
    }
    
    var discountPercentage: Double? {
        guard let original = originalPrice, original > 0 else { return nil }
        return ((original - price) / original) * 100
    }
}
