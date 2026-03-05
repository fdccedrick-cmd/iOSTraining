//
//  FlashSaleOverlayView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import SwiftUI

struct FlashSaleOverlayView: View {
    @ObservedObject var viewModel = FlashSaleViewModel.shared

    var body: some View {
        ZStack {
            // ✅ Only show modal, no floating banner
            if viewModel.showModal {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .allowsHitTesting(true)
                    .onTapGesture {
                        viewModel.dismissModal()
                    }
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.25), value: viewModel.showModal)
                    .zIndex(998)

                VStack {
                    Spacer()
                    FlashSaleModalView()
                }
                .ignoresSafeArea()
                .transition(.move(edge: .bottom))
                .animation(.spring(response: 0.4, dampingFraction: 0.85), value: viewModel.showModal)
                .zIndex(999)
                .allowsHitTesting(true)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(viewModel.showModal)  // Only intercept when modal is visible
    }
}
