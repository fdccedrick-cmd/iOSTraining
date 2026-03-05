//
//  Networkmanager.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/27/26.
//

import Foundation
import UIKit

// MARK: - Protocol
protocol NetworkManagerDelegate: AnyObject {
    func didFetchProducts(_ products: [DummyProduct])
    func didFailWithError(_ error: Error)
}

class NetworkManager {
    static let shared = NetworkManager()

    weak var delegate: NetworkManagerDelegate?
    private let imageCache = NSCache<NSString, UIImage>()

    private init() {}

    // MARK: - Delegate based fetch (UIKit - ProductListViewController)
    func fetchProducts() {
        fetchProductsFromAPI { [weak self] result in
            switch result {
            case .success(let products):
                self?.delegate?.didFetchProducts(products)
            case .failure(let error):
                self?.delegate?.didFailWithError(error)
            }
        }
    }

    // Completion based fetch (SwiftUI - HomeViewModel)
    func fetchProducts(completion: @escaping (Result<[DummyProduct], Error>) -> Void) {
        fetchProductsFromAPI(completion: completion)
    }

    // MARK: - Shared core fetch
    private func fetchProductsFromAPI(completion: @escaping (Result<[DummyProduct], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/products?limit=20&select=title,price,description,images,rating,availabilityStatus,discountPercentage,category") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard let data = data else { return }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            do {
                let response = try decoder.decode(ProductResponse.self, from: data)
                DispatchQueue.main.async { completion(.success(response.products)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }

    // MARK: - Image fetch with cache
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = url.absoluteString as NSString

        if let cached = imageCache.object(forKey: cacheKey) {
            completion(cached)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            self?.imageCache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async { completion(image) }
        }.resume()
    }
}

    
