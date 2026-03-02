//
//  CartView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/2/26.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel = CartViewModel.shared
    @FocusState private var promoFocused: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGray6).ignoresSafeArea()

            if viewModel.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        cartHeaderView
                        cartItemsCard
                        promoCodeCard
                        summaryCard
                        Spacer().frame(height: 90) // space for checkout button
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }

                checkoutButton
            }
        }
        .navigationBarHidden(true)
        .alert("Confirm Order 🛍️", isPresented: $viewModel.showCheckoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Confirm") { viewModel.confirmCheckout() }
        } message: {
            Text("Total: \(viewModel.formattedTotal)\nProceed with your order?")
        }
    }

    // MARK: - Header
    private var cartHeaderView: some View {
        HStack {
            Text("Your Cart")
                .font(.system(size: 28, weight: .bold))

            Text("\(viewModel.itemCount)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Color.black)
                .clipShape(Circle())

            Spacer()

            // Clear button
            Button {
                viewModel.clearCart()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 22))
                    .foregroundColor(.primary)
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Cart Items Card
    private var cartItemsCard: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.items.indices, id: \.self) { index in
                CartRowView(
                    item: viewModel.items[index],
                    index: index,
                    viewModel: viewModel
                )
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Promo Code Card
    private var promoCodeCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Promo Code")
                .font(.system(size: 15, weight: .semibold))

            HStack {
                Image(systemName: "ticket")
                    .foregroundColor(.gray)

                TextField("Add discount code", text: $viewModel.promoCode)
                    .focused($promoFocused)
                    .font(.system(size: 15))
                    .autocorrectionDisabled()
                    .autocapitalization(.allCharacters)

                Button("Apply") {
                    promoFocused = false
                    viewModel.applyPromo()
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.black)
                .clipShape(Capsule())
            }
            .padding(14)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            if viewModel.promoApplied {
                Text("✅ Promo code applied!")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
    }

    // MARK: - Summary Card
    private var summaryCard: some View {
        VStack(spacing: 0) {
            summaryRow(title: "Subtotal", value: viewModel.formattedSubtotal, isBold: false)

            Divider().padding(.horizontal, 16)

            summaryRow(title: "Estimated Shipping", value: viewModel.formattedShipping, isBold: false)

            Divider().padding(.horizontal, 16)

            summaryRow(title: "Total", value: viewModel.formattedTotal, isBold: true)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func summaryRow(title: String, value: String, isBold: Bool) -> some View {
        HStack {
            Text(title)
                .font(.system(size: isBold ? 17 : 14, weight: isBold ? .bold : .regular))
                .foregroundColor(isBold ? .primary : .secondary)
            Spacer()
            Text(value)
                .font(.system(size: isBold ? 20 : 14, weight: isBold ? .bold : .regular))
                .foregroundColor(isBold ? .primary : .secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    // MARK: - Checkout Button
    private var checkoutButton: some View {
        Button(action: viewModel.checkout) {
            HStack {
                Text("Go to Checkout")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Text(viewModel.formattedTotal)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "cart.badge.minus")
                .font(.system(size: 70))
                .foregroundColor(.gray.opacity(0.4))
            Text("Your Cart is Empty")
                .font(.title2.bold())
            Text("Add items to your cart\nand they will appear here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CartView()
}
