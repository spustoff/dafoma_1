//
//  VisualSettingsView.swift
//  PulseGrid Studio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct VisualSettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let mode: VisualMode
    @Binding var settings: VisualSettings
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: mode.iconName)
                        .font(.system(size: 40))
                        .foregroundColor(settings.colorOverlay.accent.color)
                    
                    Text("\(mode.rawValue) Settings")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Speed Control
                        SettingSection(
                            title: "Animation Speed",
                            description: "Controls the animation playback rate"
                        ) {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Speed")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(Int(settings.speed * 100))%")
                                        .foregroundColor(PulseGridColors.accent)
                                }
                                
                                Slider(value: $settings.speed, in: 0.1...2.0)
                                    .accentColor(PulseGridColors.accent)
                                
                                HStack {
                                    Text("Slow")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                    Spacer()
                                    Text("Fast")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                        }
                        
                        // Brightness Control
                        SettingSection(
                            title: "Brightness",
                            description: "Adjusts the visual intensity and opacity"
                        ) {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Brightness")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(Int(settings.brightness * 100))%")
                                        .foregroundColor(PulseGridColors.accent)
                                }
                                
                                Slider(value: $settings.brightness, in: 0.1...1.0)
                                    .accentColor(PulseGridColors.accent)
                                
                                HStack {
                                    Text("Dim")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                    Spacer()
                                    Text("Bright")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                        }
                        
                        // Line Width Control
                        SettingSection(
                            title: "Line Width",
                            description: "Thickness of lines and visual elements"
                        ) {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Width")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(settings.lineWidth, specifier: "%.1f")px")
                                        .foregroundColor(PulseGridColors.accent)
                                }
                                
                                Slider(value: $settings.lineWidth, in: 0.5...5.0)
                                    .accentColor(PulseGridColors.accent)
                                
                                HStack {
                                    Text("Thin")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                    Spacer()
                                    Text("Thick")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                        }
                        
                        // Color Scheme Selection
                        SettingSection(
                            title: "Color Scheme",
                            description: "Choose from predefined or custom color palettes"
                        ) {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(appState.customColorSchemes) { scheme in
                                    ColorSchemeCard(
                                        scheme: scheme,
                                        isSelected: settings.colorOverlay.id == scheme.id
                                    ) {
                                        settings.colorOverlay = scheme
                                    }
                                }
                            }
                        }
                        
                        // Reset Button
                        Button("Reset to Defaults") {
                            settings = .default
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(PulseGridColors.danger.opacity(0.8))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            .background(PulseGridColors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(PulseGridColors.accent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(PulseGridColors.accent)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct SettingSection<Content: View>: View {
    let title: String
    let description: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: 12) {
            // Section header
            VStack(spacing: 4) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                
                HStack {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                }
            }
            
            // Section content
            content
        }
        .padding(16)
        .background(PulseGridColors.secondaryBackground)
        .cornerRadius(12)
    }
}

struct ColorSchemeCard: View {
    let scheme: CustomColorScheme
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            // Color preview
            HStack(spacing: 4) {
                Circle()
                    .fill(scheme.primary.color)
                    .frame(width: 16, height: 16)
                Circle()
                    .fill(scheme.secondary.color)
                    .frame(width: 16, height: 16)
                Circle()
                    .fill(scheme.accent.color)
                    .frame(width: 16, height: 16)
            }
            
            Text(scheme.name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .padding(12)
        .background(isSelected ? PulseGridColors.accent.opacity(0.3) : PulseGridColors.background)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? PulseGridColors.accent : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    VisualSettingsView(mode: .signalMesh, settings: .constant(.default))
        .environmentObject(AppState())
} 