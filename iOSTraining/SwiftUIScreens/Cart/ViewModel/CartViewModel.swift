//
//  CartViewModel.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/2/26.
//

import Foundation
import Combine

class CartViewModel: ObservableObject {
    static let shared = CartViewModel()

    @Published var items: [CartItem] = [] {
        didSet {
            saveToUsersDefaults()
        }
    }
    @Published var showCheckoutAlert: Bool = false

    private let cartKey = "saved_cart_items"
    
    init () {
        loadfromUsersDefaults()
    }
    
    var total: Double {
        items.reduce(0) { $0 + $1.price }
    }

    var formattedTotal: String {
        String(format: "₱%.2f", total)
    }

    var isEmpty: Bool {
        items.isEmpty
    }

    var itemCount: Int {
        items.count
    }

    func addItem(_ item: CartItem) {
        items.append(item)
    }

    func removeItem(at index: Int) {
        guard index < items.count else { return }
        items.remove(at: index)
    }

    func clearCart() {
        items.removeAll()
    }

    func checkout() {
        showCheckoutAlert = true
    }

    func confirmCheckout() {
        clearCart()
    }
    
    private func saveToUsersDefaults() {
        do {
            let encoded = try JSONEncoder().encode(items)
            UserDefaults.standard.set(encoded, forKey: cartKey)
        } catch {
            print ("Failed to saved cart : \(error)")
        }
    }
    
    private func loadfromUsersDefaults() {
        guard let data = UserDefaults.standard.data(forKey: cartKey) else { return }
        do {
            items = try JSONDecoder().decode([CartItem].self, from: data)
        } catch {
            print ("Failed to load cart: \(error)")
        }
    }
    
}
