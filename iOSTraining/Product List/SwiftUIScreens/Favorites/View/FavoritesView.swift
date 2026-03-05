//
//  FavoritesView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/3/26.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel = FavoritesViewModel.shared
    @State private var toastMessage: String? = nil
    var body: some View {
        ZStack(alignment: . bottom) {
            Color(.systemGray6).ignoresSafeArea()
            
            if viewModel.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        headerView
                        favoritesCard
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                
            }
            if let message = toastMessage {
                Text("  \(message)  ")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.75))
                    .clipShape(Capsule())
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 16)
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            Text("Favorites")
                .font(.system(size: 28, weight: .bold))
            
            Text("\(viewModel.itemCount)")
                .font(.system(size:14, weight: .bold))
                .foregroundColor(.white)
                .frame(width:28, height: 28)
                .background(Color.black)
                .clipShape(Circle())
            
            Spacer()
            
            Button {
                withAnimation{
                    viewModel.items.removeAll()
                }
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.system(size:22))
                    .foregroundColor(.primary)
            }
        }
//        .padding(.top, 8)
    }
    
    private var favoritesCard: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.items.indices, id: \.self) { index in
                FavoritesRowView(
                    item: viewModel.items[index],
                    onRemove: {
                        withAnimation{
                            viewModel.removeItem(at: index)
                        }
                    },
                    onAddToCart: {
                        viewModel.addToCart(viewModel.items[index])
                        
                    }
                )
                
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: . black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var emptyStateView: some View {
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: "heart.slash")
                    .font(.system(size: 70, weight: .light))
                    .foregroundColor(.gray.opacity(0.4))

                Text("No Favorites Yet")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)

                Text("Items you love will appear here.\nSwipe right on any product to save.")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

        // MARK: - Toast
    private func showToast(_ message: String) {
        withAnimation { toastMessage = message }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { toastMessage = nil }
        }
    }
}

#Preview {
    FavoritesView()
}
