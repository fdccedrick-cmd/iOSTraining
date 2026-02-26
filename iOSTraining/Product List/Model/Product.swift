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
    
    // convenience init — reuses single image 3 times
        init(image: String?, name: String, price: Double, description: String) {
            self.image = image
            self.name = name
            self.price = price
            self.description = description
            // reuse same image 3x as placeholder carousel
            self.images = [image, image, image].compactMap { $0 }
        }
    
}
