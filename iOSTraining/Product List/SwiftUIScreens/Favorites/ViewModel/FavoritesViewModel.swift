//
//  FavoritesViewModel.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/3/26.
//

import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
    static let shared = FavoritesViewModel()
    
    @Published var items: [FavoriteItem] = [] {
        didSet { saveToUserDefaults() }
    }
    
    private let favKey = "saved_favorite_items"
    
    init() {
        loadFromUserDefaults()
    }
    
    var isEmpty: Bool {items.isEmpty}
    var itemCount: Int {items.count}
    
    func addItem(_ item: FavoriteItem) {
        guard !items.contains(where: {$0.title == item.title }) else { return }
        items.append(item)
    }
    
    func removeItem(at index: Int) {
        guard index < items.count else { return }
        items.remove(at: index)
    }
    
    func removeItem(_ item: FavoriteItem){
        items.removeAll { $0.id == item.id }
    }
    
    func isItemFavorited(_ title: String) -> Bool {
        items.contains(where: {$0.title == title })
    }
    
    func addToCart(_ item: FavoriteItem) {
        // Check if product is on flash sale using productId
        var saleInfo = (isOnSale: false, salePrice: nil as Double?, originalPrice: nil as Double?)
        if let productId = item.productId {
            saleInfo = FlashSaleViewModel.shared.getSaleInfo(forProductId: productId)
        }
        
        let cartItem = CartItem(
            title: item.title,
            price: saleInfo.isOnSale ? saleInfo.salePrice! : item.price,
            imageURL: item.imageURL,
            quantity: 1,
            isSelected: false,
            isFlashSale: saleInfo.isOnSale,
            originalPrice: saleInfo.isOnSale ? saleInfo.originalPrice : nil,
            productId: item.productId
        )
        
        CartViewModel.shared.addItem(cartItem)
    }
    
    
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(items){
            UserDefaults.standard.set(encoded, forKey: favKey)
        }
    }
    
    private func loadFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: favKey),
              let decoded = try? JSONDecoder().decode([FavoriteItem].self, from: data) else {return }
            items = decoded
    }
    
}
