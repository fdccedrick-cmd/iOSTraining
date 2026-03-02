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
            saveToUserDefaults()
        }
    }
    @Published var showCheckoutAlert: Bool = false
    @Published var promoCode: String = ""
    @Published var promoApplied: Bool = false

    private let cartKey = "saved_cart_items"
    private let shippingFee: Double = 15.00
    
    
    init () {
        loadFromUserDefaults()
    }
    
    var subTotal: Double {
        items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    var total: Double {
        subTotal + shippingFee
    }

    var formattedSubtotal: String { String(format: "₱%.2f" , subTotal) }
    var formattedShipping: String { String(format: "₱%.2f", shippingFee) }
    var formattedTotal: String {String(format: "₱%.2f", total)}
    var isEmpty: Bool { items.isEmpty }
    var itemCount: Int { items.reduce(0) { $0 + $1.quantity} }
    
    func addItem(_ item: CartItem) {
        if let index =  items.firstIndex(where: { $0.title == item.title}){
            items[index].quantity += 1
        } else {
            items.append(item)
        }
    }
    
    func removeItem(at index: Int) {
        guard index < items.count else { return }
        items.remove(at: index)
    }
    
    func increaseQuantity(at index: Int) {
        guard index < items.count else { return }
        items[index].quantity += 1
    }
    
    func decreaseQuantity(at index: Int) {
        guard index < items.count else { return }
        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
        }
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
    
    func applyPromo() {
        promoApplied = !promoCode.isEmpty
    }
    
    private func saveToUserDefaults() {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: cartKey)
            }
        }

    private func loadFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: cartKey),
              let decoded = try? JSONDecoder().decode([CartItem].self, from: data) else { return }
        items = decoded
    }
    
}
