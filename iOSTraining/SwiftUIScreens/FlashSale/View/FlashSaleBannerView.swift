//
//  FlashSaleBannerView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import SwiftUI

struct FlashSaleBannerView: View {
    @ObservedObject var viewModel = FlashSaleViewModel.shared
    @State private var currentPosition: CGPoint = CGPoint(
        x: UIScreen.main.bounds.width - 90,
        y: UIScreen.main.bounds.height - 160
    )
    @State private var dragOffset: CGSize = .zero
    @State private var pulseScale: CGFloat = 1.0
    @State private var isDragging: Bool = false
    @State private var dragDistance: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Passthrough layer
                Color.clear
                    .contentShape(Rectangle())
                    .allowsHitTesting(false)
                
                // Banner layer (can receive touches)
                bannerContent
                    .fixedSize()
                    .position(currentPosition)
                    .offset(x: viewModel.swayOffset)  // ✅ sway
                    .scaleEffect(pulseScale)           // ✅ pulse
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                guard viewModel.state != .saleEnded else { return }
                                isDragging = true
                                dragDistance = sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2))
                                
                                // Only drag if moved more than 15 points
                                if dragDistance > 15 {
                                    let newX = currentPosition.x + value.translation.width - dragOffset.width
                                    let newY = currentPosition.y + value.translation.height - dragOffset.height
                                    dragOffset = value.translation

                                    let halfW: CGFloat = 90
                                    let halfH: CGFloat = 50
                                    currentPosition = CGPoint(
                                        x: min(max(newX, halfW), geo.size.width - halfW),
                                        y: min(max(newY, halfH + 50), geo.size.height - halfH - 90)
                                    )
                                }
                            }
                            .onEnded { _ in
                                // Tap if minimal movement
                                if dragDistance < 15 && viewModel.isBannerClickable {
                                    withAnimation(.spring(response: 0.3)) {
                                        viewModel.openModal()
                                    }
                                } else if dragDistance >= 15 {
                                    // Drag - snap to side
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        let midX = geo.size.width / 2
                                        currentPosition.x = currentPosition.x < midX
                                            ? 90
                                            : geo.size.width - 90
                                    }
                                }
                                dragOffset = .zero
                                isDragging = false
                                dragDistance = 0
                            }
                    )
                    .animation(.easeInOut(duration: 0.3), value: viewModel.state)
                    .background(
                        // Invisible background to expand hit test area
                        Color.clear
                            .frame(width: 190, height: 110)
                            .contentShape(Rectangle())
                    )
            }
            .onAppear {
                currentPosition = CGPoint(
                    x: geo.size.width - 90,
                    y: geo.size.height - 160
                )
            }
            .onChange(of: viewModel.isPulsing) { pulsing in
                if pulsing {
                    startPulse()
                } else {
                    stopPulse()
                }
            }
        }
    }

    // MARK: - Banner Content
    private var bannerContent: some View {
        VStack(spacing: 6) {
            // Main banner row
            HStack(spacing: 8) {
                Text(FlashSaleConfig.bannerEmoji)
                    .font(.system(size: 16))

                VStack(alignment: .leading, spacing: 1) {
                    Text(viewModel.bannerLabel)
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(labelColor)
                        .tracking(1.5)

                    Text(viewModel.bannerTime)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                }

                // Urgent pulse dot
                if viewModel.isUrgent {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 7, height: 7)
                        .modifier(PulseEffect())
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            // ✅ Shop Now button — only visible when sale is active
            if viewModel.state == .saleActive {
                HStack(spacing: 4) {
                    Text("Shop Now")
                        .font(.system(size: 11, weight: .bold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 9, weight: .bold))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color.yellow)
                .clipShape(Capsule())
                .padding(.bottom, 8)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .background(bannerBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: shadowColor.opacity(viewModel.state == .saleActive ? 0.6 : 0.3),
            radius: viewModel.state == .saleActive ? 16 : 8,
            x: 0, y: 4
        )
        .overlay(
            // ✅ Glowing border when sale active
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    viewModel.state == .saleActive
                        ? Color.yellow.opacity(0.6)
                        : Color.clear,
                    lineWidth: 1.5
                )
        )
        .contentShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Dynamic Styling
    private var bannerBackground: some View {
        Group {
            switch viewModel.state {
            case .countingDown:
                LinearGradient(
                    colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            case .saleActive:
                LinearGradient(
                    colors: [Color(hex: "FF4500"), Color(hex: "FF6B00")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            case .saleEnded:
                LinearGradient(
                    colors: [Color(.systemGray3), Color(.systemGray4)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
        }
    }

    private var labelColor: Color {
        switch viewModel.state {
        case .countingDown: return Color(.systemGray3)
        case .saleActive:   return .yellow
        case .saleEnded:    return .white
        }
    }

    private var shadowColor: Color {
        switch viewModel.state {
        case .countingDown: return Color(hex: "1a1a2e")
        case .saleActive:   return Color(hex: "FF4500")
        case .saleEnded:    return .clear
        }
    }

    // MARK: - Pulse
    private func startPulse() {
        withAnimation(
            .easeInOut(duration: 0.7)
            .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.06
        }

            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                stopPulse()
            }
    }

    private func stopPulse() {
        withAnimation { pulseScale = 1.0 }
    }
}
struct PulseEffect: ViewModifier {
    @State private var isPulsing = false
    @State private var isVisible = true

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.4 : 1.0)
            .opacity(isPulsing ? 0.5 : 1.0)
            .opacity(isVisible ? 1 : 0)
            .animation(
                .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isPulsing = false
                        isVisible = false
                    }
                }
            }
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

