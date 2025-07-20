//
//  ModeSelectionView.swift
//  PulseGrid
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct ModeSelectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedMode: VisualMode?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("PulseGrid")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Visual Pattern Reference Tool")
                        .font(.subheadline)
                        .foregroundColor(PulseGridColors.gold)
                }
                .padding(.top, 20)
                
                // Mode Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(VisualMode.allCases) { mode in
                        ModeCard(mode: mode)
                            .onTapGesture {
                                appState.currentMode = mode
                                selectedMode = mode
                            }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Animation Intensity Control
                VStack(spacing: 12) {
                    HStack {
                        Text("Animation Intensity")
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(Int(appState.animationIntensity * 100))%")
                            .foregroundColor(PulseGridColors.accent)
                    }
                    
                    Slider(value: $appState.animationIntensity, in: 0.1...1.0)
                        .accentColor(PulseGridColors.accent)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(PulseGridColors.background)
            .navigationBarHidden(true)
        }
        .fullScreenCover(item: $selectedMode) { mode in
            VisualDisplayView(mode: mode)
        }
    }
}

struct ModeCard: View {
    @EnvironmentObject var appState: AppState
    let mode: VisualMode
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon and favorite button
            HStack {
                Image(systemName: mode.iconName)
                    .font(.system(size: 24))
                    .foregroundColor(PulseGridColors.accent)
                
                Spacer()
                
                Button(action: {
                    appState.toggleFavorite(mode)
                }) {
                    Image(systemName: appState.isFavorite(mode) ? "heart.fill" : "heart")
                        .foregroundColor(appState.isFavorite(mode) ? PulseGridColors.danger : .white.opacity(0.6))
                }
            }
            
            // Title
            Text(mode.rawValue)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            // Description
            Text(mode.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .padding(16)
        .background(PulseGridColors.secondaryBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(appState.currentMode == mode ? PulseGridColors.accent : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    ModeSelectionView()
        .environmentObject(AppState())
} 