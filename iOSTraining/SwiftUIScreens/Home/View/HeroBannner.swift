//
//  HeroBannner.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import SwiftUI

struct HeroBannerView: View {
    @ObservedObject var viewModel = HomeViewModel.shared
    @State private var isAnimating = false

    var body: some View {
        TabView(selection: $viewModel.currentBannerIndex) {
            ForEach(viewModel.banners.indices, id: \.self) { index in
                bannerCard(viewModel.banners[index])
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(alignment: .bottomTrailing) {
            HStack(spacing: 6) {
                ForEach(viewModel.banners.indices, id: \.self) { index in
                    Capsule()
                        .fill(Color.white.opacity(index == viewModel.currentBannerIndex ? 1 : 0.4))
                        .frame(
                            width: index == viewModel.currentBannerIndex ? 20 : 6,
                            height: 6
                        )
                        .animation(.spring(response: 0.3), value: viewModel.currentBannerIndex)
                }
            }
            .padding(16)
        }
    }

    private func bannerCard(_ banner: HomeBanner) -> some View {
        ZStack {
            LinearGradient(
                colors: banner.gradientColors.map { Color(hex: $0) },
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 200, height: 200)
                .offset(x: 100, y: -60)
                .blur(radius: 2)

            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 150, height: 150)
                .offset(x: -80, y: 60)

            HStack {
                VStack(alignment: .leading, spacing: 10) {
                   
                    Text(banner.badge)
                        .font(.system(size: 10, weight: .black))
                        .tracking(2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )

                    Text(banner.title)
                        .font(.system(size: 26, weight: .black))
                        .foregroundColor(.white)

                    Text(banner.subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))

                    HStack(spacing: 6) {
                        Text("Shop Now")
                            .font(.system(size: 12, weight: .bold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.4), lineWidth: 1)
                    )
                }
                .padding(24)

                Spacer()
            }
        }
    }
}
