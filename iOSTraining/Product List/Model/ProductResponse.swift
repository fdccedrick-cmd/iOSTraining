//
//  ProductResponse.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/27/26.
//
import Foundation

struct ProductResponse: Decodable {
    let products: [DummyProduct]
}

struct DummyProduct: Codable {
//    let id: Int
    let title: String
    let price: Double
    let description: String
//    let category: String
//    let rating: Double
    let images: [String]
    
    var paddedImages: [String] {
           guard !images.isEmpty else { return [] }
           var result = images
           while result.count < 3 {
               result.append(images[result.count % images.count])
           }
           return result
       }
}
