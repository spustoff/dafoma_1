//
//  VisualModeView.swift
//  PulseGrid Studio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct VisualModeView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedMode: VisualMode?
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("AviGrid Studio")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Professional Grid & Pattern Designer")
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
                        EnhancedModeCard(mode: mode)
                            .onTapGesture {
                                appState.currentMode = mode
                                selectedMode = mode
                            }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Quick Controls
                VStack(spacing: 16) {
                    HStack {
                        Button("Settings") {
                            showingSettings = true
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(PulseGridColors.secondaryBackground)
                        .cornerRadius(8)
                        
                        Spacer()
                        
                        Button("Color Schemes") {
                            appState.showingColorSchemeManager = true
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(PulseGridColors.gold.opacity(0.8))
                        .cornerRadius(8)
                    }
                    
                    // Animation Intensity Control
                    VStack(spacing: 12) {
                        HStack {
                            Text("Global Animation Intensity")
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(Int(appState.animationIntensity * 100))%")
                                .foregroundColor(PulseGridColors.accent)
                        }
                        
                        Slider(value: $appState.animationIntensity, in: 0.1...1.0)
                            .accentColor(PulseGridColors.accent)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(PulseGridColors.background)
            .navigationBarHidden(true)
        }
        .fullScreenCover(item: $selectedMode) { mode in
            EnhancedVisualDisplayView(mode: mode)
        }
        .sheet(isPresented: $showingSettings) {
            VisualSettingsView(mode: appState.currentMode, settings: .constant(appState.settingsFor(appState.currentMode)))
        }
        .sheet(isPresented: $appState.showingColorSchemeManager) {
            ColorSchemeManagerView()
        }
    }
}

struct EnhancedModeCard: View {
    @EnvironmentObject var appState: AppState
    let mode: VisualMode
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon and controls
            HStack {
                Image(systemName: mode.iconName)
                    .font(.system(size: 24))
                    .foregroundColor(appState.settingsFor(mode).colorOverlay.primary.color)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: {
                        appState.toggleFavorite(mode)
                    }) {
                        Image(systemName: appState.isFavorite(mode) ? "heart.fill" : "heart")
                            .foregroundColor(appState.isFavorite(mode) ? PulseGridColors.danger : .white.opacity(0.6))
                    }
                    
                    Button(action: {
                        appState.startExternalDisplay(mode: mode, settings: appState.settingsFor(mode))
                    }) {
                        Image(systemName: "tv")
                            .foregroundColor(PulseGridColors.accent)
                    }
                }
            }
            
            // Title
            Text(mode.rawValue)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            // Settings preview
            HStack(spacing: 4) {
                Circle()
                    .fill(appState.settingsFor(mode).colorOverlay.primary.color)
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(appState.settingsFor(mode).colorOverlay.secondary.color)
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(appState.settingsFor(mode).colorOverlay.accent.color)
                    .frame(width: 8, height: 8)
            }
            
            // Description
            Text(mode.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(2)
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

// MARK: - String to Color Extension
extension String {
    var color: Color {
        Color(hex: self)
    }
}

#Preview {
    VisualModeView()
        .environmentObject(AppState())
} 