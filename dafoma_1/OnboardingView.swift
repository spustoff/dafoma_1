//
//  OnboardingView.swift
//  PulseGrid
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Welcome to AviGrid Studio",
            subtitle: "Professional Grid & Pattern Designer",
            description: "Create dynamic visual grids and patterns for technical visualization, creative projects, and professional presentations.",
            iconName: "grid"
        ),
        OnboardingPage(
            title: "Grid Customization",
            subtitle: "Precision Control",
            description: "Fine-tune speed, brightness, line thickness, and color schemes. Design custom grid patterns and save your configurations.",
            iconName: "slider.horizontal.3"
        ),
        OnboardingPage(
            title: "Studio Features",
            subtitle: "Complete Design Toolkit",
            description: "Build grid compositions, export high-quality patterns, and present your work with professional studio tools.",
            iconName: "rectangle.grid.2x2"
        ),
        OnboardingPage(
            title: "Studio Display",
            subtitle: "Professional Presentation",
            description: "Connect to external displays for grid previews, installation design, and professional studio presentations.",
            iconName: "tv"
        )
    ]
    
    var body: some View {
        VStack(spacing: 40) {
            // Header
            VStack(spacing: 16) {
                Image(systemName: pages[currentPage].iconName)
                    .font(.system(size: 60))
                    .foregroundColor(PulseGridColors.accent)
                
                Text(pages[currentPage].title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(pages[currentPage].subtitle)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(PulseGridColors.gold)
            }
            
            // Description
            Text(pages[currentPage].description)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
            
            // Page indicator
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? PulseGridColors.accent : Color.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            
            // Navigation buttons
            HStack(spacing: 20) {
                if currentPage > 0 {
                    Button("Previous") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage -= 1
                        }
                    }
                    .foregroundColor(PulseGridColors.accent)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(PulseGridColors.secondaryBackground)
                    .cornerRadius(8)
                }
                
                Spacer()
                
                Button(currentPage == pages.count - 1 ? "Get Started" : "Next") {
                    if currentPage == pages.count - 1 {
                        appState.hasSeenOnboarding = true
                    } else {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(PulseGridColors.accent)
                .cornerRadius(8)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(PulseGridColors.background)
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let iconName: String
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
} 