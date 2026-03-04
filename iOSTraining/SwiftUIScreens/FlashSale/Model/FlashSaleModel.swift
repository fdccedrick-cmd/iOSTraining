//
//  FlashSaleModel.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import Foundation


enum FlashSaleConfig {
    static let saleDurationSeconds: TimeInterval = 1 * 60
    static let saleLabel: String = "FLASH SALE"
    static let bannerEmoji: String = "⚡️"
}


struct FlashSaleItem: Identifiable {
    let id: UUID = UUID()
    let product: DummyProduct
    
    
    var originalPrice: Double {
        product.price
    }
    
    var salePrice: Double {
        originalPrice * (1 - product.discountPercentage / 100)
    }
    
    var formattedOriginalPrice: String {
        String (format: "₱%.2f" , originalPrice)
    }
    
    var formattedSalePrice: String {
        String (format: "₱%.2f" , salePrice)
    }
    
    var discountLabel: String {
        String (format: "-%.0f%%" , product.discountPercentage)
    }
    
    var hadDiscount: Bool {
        product.discountPercentage > 0
    }
}
