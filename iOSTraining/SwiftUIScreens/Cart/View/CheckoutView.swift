//
//  CheckoutView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/3/26.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var viewModel = CartViewModel.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var fullName: String = ""
    @State private var phoneNumber: String = ""
    @State private var address: String = ""
    @State private var selectedPaymentMethod: PaymentMethod = .cod
    @State private var showSuccessAlert = false
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                customNavigationBar
                
                ScrollView {
                    VStack(spacing: 12) {
                        // Shipping Address Card
                        shippingAddressCard
                        
                        // Order Items Card
                        orderItemsCard
                        
                        // Payment Method Card
                        paymentMethodCard
                        
                        // Order Summary Card
                        orderSummaryCard
                        
                        Spacer().frame(height: 100) // Space for button
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                placeOrderButton
            }
        }
        .alert("Order Placed Successfully! 🎉", isPresented: $showSuccessAlert) {
            Button("OK") {
                viewModel.confirmCheckout()
                dismiss()
            }
        } message: {
            Text("Your order has been placed successfully!\nTotal: \(viewModel.formattedTotal)")
        }
    }
    
    // MARK: - Custom Navigation Bar
    private var customNavigationBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 17))
                }
                .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Checkout")
                .font(.system(size: 18, weight: .semibold))
            
            Spacer()
            
            // Invisible placeholder for balance
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                Text("Back")
                    .font(.system(size: 17))
            }
            .opacity(0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Shipping Address Card
    private var shippingAddressCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                
                Text("Shipping Address")
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                CustomTextField(
                    icon: "person.fill",
                    placeholder: "Full Name",
                    text: $fullName
                )
                
                CustomTextField(
                    icon: "phone.fill",
                    placeholder: "Phone Number",
                    text: $phoneNumber,
                    keyboardType: .phonePad
                )
                
                CustomTextField(
                    icon: "house.fill",
                    placeholder: "Complete Address",
                    text: $address,
                    isMultiline: true
                )
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Order Items Card
    private var orderItemsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bag.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                
                Text("Order Items")
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
                
                Text("\(viewModel.selectedItemCount) items")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            ForEach(viewModel.selectedItems.indices, id: \.self) { index in
                CheckoutItemRow(item: viewModel.selectedItems[index])
                
                if index < viewModel.selectedItems.count - 1 {
                    Divider()
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Payment Method Card
    private var paymentMethodCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "creditcard.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                
                Text("Payment Method")
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
            }
            
            VStack(spacing: 10) {
                PaymentMethodOption(
                    icon: "banknote.fill",
                    title: "Cash on Delivery",
                    subtitle: "Pay when you receive",
                    isSelected: selectedPaymentMethod == .cod
                ) {
                    selectedPaymentMethod = .cod
                }
                
                PaymentMethodOption(
                    icon: "creditcard.fill",
                    title: "Credit/Debit Card",
                    subtitle: "Visa, Mastercard",
                    isSelected: selectedPaymentMethod == .card
                ) {
                    selectedPaymentMethod = .card
                }
                
                PaymentMethodOption(
                    icon: "wallet.pass.fill",
                    title: "E-Wallet",
                    subtitle: "GCash, PayMaya",
                    isSelected: selectedPaymentMethod == .ewallet
                ) {
                    selectedPaymentMethod = .ewallet
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Order Summary Card
    private var orderSummaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "doc.text.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                
                Text("Order Summary")
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                summaryRow(title: "Subtotal", value: viewModel.formattedSubtotal)
                summaryRow(title: "Shipping Fee", value: viewModel.formattedShipping)
                
                Divider()
                
                HStack {
                    Text("Total Payment")
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                    
                    Text(viewModel.formattedTotal)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
    }
    
    private func summaryRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .medium))
        }
    }
    
    // MARK: - Place Order Button
    private var placeOrderButton: some View {
        Button(action: placeOrder) {
            HStack {
                Text("Place Order")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(viewModel.formattedTotal)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [Color.black, Color.gray],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .disabled(!isFormValid)
        .opacity(isFormValid ? 1.0 : 0.5)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
        .background(
            Color(.systemBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
                .ignoresSafeArea(edges: .bottom)
        )
    }
    
    private var isFormValid: Bool {
        !fullName.isEmpty && !phoneNumber.isEmpty && !address.isEmpty
    }
    
    private func placeOrder() {
        showSuccessAlert = true
    }
}

// MARK: - Supporting Views

struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isMultiline: Bool = false
    
    var body: some View {
        HStack(alignment: isMultiline ? .top : .center, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .font(.system(size: 14))
                .frame(width: 20)
                .padding(.top, isMultiline ? 12 : 0)
            
            if isMultiline {
                TextField(placeholder, text: $text, axis: .vertical)
                    .font(.system(size: 14))
                    .lineLimit(3...6)
                    .keyboardType(keyboardType)
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .keyboardType(keyboardType)
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct CheckoutItemRow: View {
    let item: CartItem
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: item.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(2)
                
                Text("x\(item.quantity)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(String(format: "₱%.2f", item.price * Double(item.quantity)))
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
        }
    }
}

struct PaymentMethodOption: View {
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(isSelected ? .black : .gray)
                    .font(.system(size: 20))
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .black : .gray.opacity(0.3))
                    .font(.system(size: 22))
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.black.opacity(0.05) : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.black : Color.clear, lineWidth: 1.5)
            )
        }
    }
}

enum PaymentMethod {
    case cod
    case card
    case ewallet
}

#Preview {
    CheckoutView()
}
