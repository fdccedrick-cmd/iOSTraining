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
            // Transparent background that passes through touches
            Color.clear
                .contentShape(Rectangle())
                .allowsHitTesting(false)
            
            // Banner — only its own frame is interactive
            if viewModel.showBanner {
                FlashSaleBannerView()
            }

            // Modal — full interactive when visible
            if viewModel.showModal {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.dismissModal()
                    }
                
                FlashSaleModalView()
                    .ignoresSafeArea()
                    .transition(.move(edge: .bottom))
                    .animation(.spring(response: 0.4), value: viewModel.showModal)
                    .zIndex(999)
            }
        }
        .ignoresSafeArea()
    }
}
