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

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGray6).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    // Order Summary
                    sectionCard(title: "Order Summary") {
                        ForEach(viewModel.items) { item in
                            HStack {
                                Text(item.title)
                                    .font(.system(size: 15))
                                Spacer()
                                Text("x\(item.quantity)")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 14))
                                Text(String(format: "₱%.2f", item.price * Double(item.quantity)))
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    // Cost Breakdown
                    sectionCard(title: "Payment Summary") {
                        summaryRow("Subtotal", value: viewModel.formattedSubtotal)
                        Divider()
                        summaryRow("Shipping", value: viewModel.formattedShipping)
                        Divider()
                        summaryRow("Total", value: viewModel.formattedTotal, isBold: true)
                    }

                    Spacer().frame(height: 90)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }

            // Confirm Button
            Button(action: {
                viewModel.confirmCheckout()
                dismiss()
            }) {
                HStack {
                    Text("Confirm Order")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text(viewModel.formattedTotal)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
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
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Helpers
    @ViewBuilder
    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.top, 16)
            Divider()
            VStack(spacing: 8) {
                content()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func summaryRow(_ title: String, value: String, isBold: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(.system(size: isBold ? 17 : 14, weight: isBold ? .bold : .regular))
                .foregroundColor(isBold ? .primary : .secondary)
            Spacer()
            Text(value)
                .font(.system(size: isBold ? 20 : 14, weight: isBold ? .bold : .regular))
                .foregroundColor(isBold ? .primary : .secondary)
        }
        .padding(.vertical, 4)
    }
}
