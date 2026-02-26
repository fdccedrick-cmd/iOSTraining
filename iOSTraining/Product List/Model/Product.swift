//
//  Product.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/25/26.
//

import Foundation

struct Product {
    let image: String?
    let images: [String]
    let name: String
    let price: Double
    let description: String
    
    // Original init — single image (backwards compatible)
        init(image: String?, name: String, price: Double, description: String) {
            self.image = image
            self.name = name
            self.price = price
            self.description = description
            self.images = [image, image, image].compactMap { $0 }
        }
        
        // New init — multiple images for carousel
        init(images: [String], name: String, price: Double, description: String) {
            self.image = images.first
            self.images = images
            self.name = name
            self.price = price
            self.description = description
        }
    
}
