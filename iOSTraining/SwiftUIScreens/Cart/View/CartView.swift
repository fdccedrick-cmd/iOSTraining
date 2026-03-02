//
//  CartView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/2/26.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel = CartViewModel.shared
    
    var body: some View {
        VStack(spacing: 0) {
                    if viewModel.isEmpty {
                        emptyStateView
                    } else {
                        cartListView
                        checkoutBarView
                    }
                }
                .background(Color(.systemGroupedBackground))
                .navigationTitle("Cart")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    if !viewModel.isEmpty {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Clear") { viewModel.clearCart() }
                                .foregroundColor(.red)
                        }
                    }
                }
                .alert("Confirm Order 🛍️", isPresented: $viewModel.showCheckoutAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Confirm") { viewModel.confirmCheckout() }
                } message: {
                    Text("Total: \(viewModel.formattedTotal)\nProceed with your order?")
                }
            }

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

            private var cartListView: some View {
                List {
                    ForEach(viewModel.items.indices, id: \.self) { index in
                        CartRowView(item: viewModel.items[index]) {
                            viewModel.removeItem(at: index)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    }
                }
                .listStyle(.plain)
                .background(Color(.systemGroupedBackground))
            }

            private var checkoutBarView: some View {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(viewModel.itemCount) item\(viewModel.itemCount > 1 ? "s" : "")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(viewModel.formattedTotal)
                            .font(.title2.bold())
                    }
                    Spacer()
                    Button(action: viewModel.checkout) {
                        Text("Checkout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 140, height: 50)
                            .background(Color.green)
                            .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: -2)
            
        
       }
}

#Preview {
    NavigationView {
            CartView()
        }
}
