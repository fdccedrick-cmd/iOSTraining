//
//  FlashSaleBannerView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import SwiftUI

struct FlashSaleBannerView: View {
    @ObservedObject var viewModel = FlashSaleViewModel.shared
    @State private var draggedOffset: CGSize = .zero
    @State private var isDragging = false

    @State private var currentPosition: CGPoint = CGPoint(
        x: UIScreen.main.bounds.width - 90,
        y: UIScreen.main.bounds.height - 160
    )

    var body: some View {
        if viewModel.showBanner {
            bannerContent
                .frame(width: 160, height: 60)
                .position(
                    x: currentPosition.x + draggedOffset.width,
                    y: currentPosition.y + draggedOffset.height
                )
                .gesture(
                    DragGesture(minimumDistance: 5)
                        .onChanged { value in
                            isDragging = true
                            draggedOffset = value.translation
                        }
                        .onEnded { value in
                            isDragging = false
                            
                            let dragDistance = sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2))
                            
                            if dragDistance > 5 {
                              
                                let newX = currentPosition.x + value.translation.width
                                let newY = currentPosition.y + value.translation.height

                                let screenWidth = UIScreen.main.bounds.width
                                let screenHeight = UIScreen.main.bounds.height
                                let bannerWidth: CGFloat = 160
                                let bannerHeight: CGFloat = 60
                                let minX = bannerWidth / 2 + 16
                                let maxX = screenWidth - bannerWidth / 2 - 16
                                let minY = bannerHeight / 2 + 60  // below status bar
                                let maxY = screenHeight - bannerHeight / 2 - 90 // above tab bar

                                let clampedX = min(max(newX, minX), maxX)
                                let clampedY = min(max(newY, minY), maxY)
                                
                               
                                draggedOffset = .zero

                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    let midX = screenWidth / 2
                                    let padding: CGFloat = bannerWidth / 2 + 16

                                    if clampedX < midX {
                                        currentPosition = CGPoint(x: padding, y: clampedY)
                                    } else {
                                        currentPosition = CGPoint(x: screenWidth - padding, y: clampedY)
                                    }
                                }
                            } else {
                                draggedOffset = .zero
                                viewModel.showModal = true
                            }
                        }
                )
                .transition(.scale.combined(with: .opacity))
                .animation(.spring(response: 0.4), value: viewModel.showBanner)
        }
    }

   
    private var bannerContent: some View {
        HStack(spacing: 8) {
            Text(FlashSaleConfig.bannerEmoji)
                .font(.system(size: 18))

            VStack(alignment: .leading, spacing: 1) {
                Text(FlashSaleConfig.saleLabel)
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(.yellow)
                    .tracking(1.5)

                Text(viewModel.formattedTime)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .monospacedDigit()
            }

            if viewModel.isUrgent {
                Circle()
                    .fill(Color.red)
                    .frame(width: 7, height: 7)
                    .modifier(PulseEffect())
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            LinearGradient(
                colors: [Color(hex: "FF4500"), Color(hex: "FF6B00")],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(Capsule())
        .shadow(color: Color(hex: "FF4500").opacity(0.5), radius: 12, x: 0, y: 4)
    
        .overlay(alignment: .topTrailing) {
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
                .padding(5)
        }
    }
}

struct PulseEffect: ViewModifier {
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.4 : 1.0)
            .opacity(isPulsing ? 0.5 : 1.0)
            .animation(
                .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear { isPulsing = true }
    }
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255,
                            (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255,
                            int >> 16 & 0xFF,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24 & 0xFF,
                            int >> 16 & 0xFF,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

