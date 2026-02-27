//
//  ProductResponse.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/27/26.
//
import Foundation

struct ProductResponse: Codable {
    let products: [DummyProduct]
}

struct DummyProduct: Codable {
    let id: Int
    let title: String
    let price: Double
}
