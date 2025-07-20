//
//  ColorSchemeManagerView.swift
//  PulseGrid Studio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct ColorSchemeManagerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var showingCreator = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Color Schemes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Manage custom color palettes")
                        .font(.subheadline)
                        .foregroundColor(PulseGridColors.gold)
                }
                .padding(.top, 20)
                
                // Color scheme grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(appState.customColorSchemes) { scheme in
                            ColorSchemeManagerCard(scheme: scheme)
                        }
                        
                        // Add new scheme card
                        Button(action: {
                            showingCreator = true
                        }) {
                            VStack(spacing: 12) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24))
                                    .foregroundColor(PulseGridColors.accent)
                                
                                Text("Create New")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text("Custom color scheme")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity, minHeight: 120)
                            .background(PulseGridColors.secondaryBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(PulseGridColors.accent, style: StrokeStyle(lineWidth: 2, dash: [5]))
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            .background(PulseGridColors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(PulseGridColors.accent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Export All") {
                        exportColorSchemes()
                    }
                    .foregroundColor(PulseGridColors.gold)
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingCreator) {
            ColorSchemeCreatorView()
        }
    }
    
    private func exportColorSchemes() {
        // Simulate export functionality
        print("Exporting color schemes...")
    }
}

struct ColorSchemeManagerCard: View {
    @EnvironmentObject var appState: AppState
    let scheme: CustomColorScheme
    @State private var showingActionSheet = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Color preview
            HStack(spacing: 8) {
                Circle()
                    .fill(scheme.primary.color)
                    .frame(width: 20, height: 20)
                Circle()
                    .fill(scheme.secondary.color)
                    .frame(width: 20, height: 20)
                Circle()
                    .fill(scheme.accent.color)
                    .frame(width: 20, height: 20)
            }
            
            // Name
            Text(scheme.name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            // Color codes preview
            VStack(spacing: 2) {
                Text(scheme.primary)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
                Text(scheme.secondary)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
                Text(scheme.accent)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // Actions
            HStack(spacing: 8) {
                Button("Use") {
                    // Apply to current mode
                }
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(PulseGridColors.accent)
                .cornerRadius(6)
                
                if scheme.name != "Default" {
                    Button("•••") {
                        showingActionSheet = true
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(PulseGridColors.secondaryBackground)
                    .cornerRadius(6)
                }
            }
        }
        .padding(16)
        .background(PulseGridColors.secondaryBackground)
        .cornerRadius(12)
        .confirmationDialog("Color Scheme Actions", isPresented: $showingActionSheet) {
            Button("Export JSON") {
                exportScheme()
            }
            Button("Duplicate") {
                duplicateScheme()
            }
            Button("Delete", role: .destructive) {
                deleteScheme()
            }
        }
    }
    
    private func exportScheme() {
        print("Exporting scheme: \(scheme.name)")
    }
    
    private func duplicateScheme() {
        let newScheme = CustomColorScheme(
            name: "\(scheme.name) Copy",
            primary: scheme.primary,
            secondary: scheme.secondary,
            accent: scheme.accent,
            background: scheme.background
        )
        appState.addCustomColorScheme(newScheme)
    }
    
    private func deleteScheme() {
        if let index = appState.customColorSchemes.firstIndex(where: { $0.id == scheme.id }) {
            appState.customColorSchemes.remove(at: index)
        }
    }
}

struct ColorSchemeCreatorView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var primaryColor = "#28a809"
    @State private var secondaryColor = "#e6053a"
    @State private var accentColor = "#d17305"
    @State private var backgroundColor = "#0e0e0e"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Create Color Scheme")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Design your custom palette")
                        .font(.subheadline)
                        .foregroundColor(PulseGridColors.gold)
                }
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Preview
                        VStack(spacing: 16) {
                            Text("Preview")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 16) {
                                VStack(spacing: 8) {
                                    Circle()
                                        .fill(Color(hex: primaryColor))
                                        .frame(width: 40, height: 40)
                                    Text("Primary")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(spacing: 8) {
                                    Circle()
                                        .fill(Color(hex: secondaryColor))
                                        .frame(width: 40, height: 40)
                                    Text("Secondary")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(spacing: 8) {
                                    Circle()
                                        .fill(Color(hex: accentColor))
                                        .frame(width: 40, height: 40)
                                    Text("Accent")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(spacing: 8) {
                                    Circle()
                                        .fill(Color(hex: backgroundColor))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle().stroke(.white.opacity(0.3), lineWidth: 1)
                                        )
                                    Text("Background")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(20)
                        .background(PulseGridColors.secondaryBackground)
                        .cornerRadius(12)
                        
                        // Name input
                        VStack(spacing: 8) {
                            HStack {
                                Text("Scheme Name")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            TextField("Enter name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Color inputs
                        ColorInputSection(title: "Primary Color", color: $primaryColor)
                        ColorInputSection(title: "Secondary Color", color: $secondaryColor)
                        ColorInputSection(title: "Accent Color", color: $accentColor)
                        ColorInputSection(title: "Background Color", color: $backgroundColor)
                        
                        // Quick presets
                        VStack(spacing: 12) {
                            HStack {
                                Text("Quick Presets")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            HStack(spacing: 12) {
                                PresetButton(name: "Electric", colors: ("#00ffff", "#ff00ff", "#ffff00", "#000033")) {
                                    applyPreset("#00ffff", "#ff00ff", "#ffff00", "#000033")
                                }
                                
                                PresetButton(name: "Fire", colors: ("#ff4500", "#ffd700", "#ff6347", "#1a0000")) {
                                    applyPreset("#ff4500", "#ffd700", "#ff6347", "#1a0000")
                                }
                                
                                PresetButton(name: "Arctic", colors: ("#87ceeb", "#4682b4", "#b0c4de", "#001122")) {
                                    applyPreset("#87ceeb", "#4682b4", "#b0c4de", "#001122")
                                }
                            }
                        }
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
                    Button("Create") {
                        createScheme()
                    }
                    .foregroundColor(PulseGridColors.accent)
                    .disabled(name.isEmpty)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func applyPreset(_ primary: String, _ secondary: String, _ accent: String, _ background: String) {
        primaryColor = primary
        secondaryColor = secondary
        accentColor = accent
        backgroundColor = background
    }
    
    private func createScheme() {
        let newScheme = CustomColorScheme(
            name: name,
            primary: primaryColor,
            secondary: secondaryColor,
            accent: accentColor,
            background: backgroundColor
        )
        appState.addCustomColorScheme(newScheme)
        dismiss()
    }
}

struct ColorInputSection: View {
    let title: String
    @Binding var color: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Circle()
                    .fill(Color(hex: color))
                    .frame(width: 24, height: 24)
            }
            
            TextField("Hex code", text: $color)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct PresetButton: View {
    let name: String
    let colors: (String, String, String, String)
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                HStack(spacing: 2) {
                    Circle().fill(Color(hex: colors.0)).frame(width: 8, height: 8)
                    Circle().fill(Color(hex: colors.1)).frame(width: 8, height: 8)
                    Circle().fill(Color(hex: colors.2)).frame(width: 8, height: 8)
                }
                Text(name)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .padding(8)
            .background(PulseGridColors.secondaryBackground)
            .cornerRadius(6)
        }
    }
}

#Preview {
    ColorSchemeManagerView()
        .environmentObject(AppState())
} 