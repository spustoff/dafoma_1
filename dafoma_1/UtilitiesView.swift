//
//  UtilitiesView.swift
//  PulseGrid Studio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct UtilitiesView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Utilities")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Advanced technical visualization tools")
                            .font(.subheadline)
                            .foregroundColor(PulseGridColors.gold)
                    }
                    .padding(.top, 20)
                    
                    // Presentation Mode Section
                    UtilitySection(
                        title: "Presentation Mode",
                        subtitle: "Full-screen visual with auto-loop",
                        icon: "play.display"
                    ) {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Duration (minutes)")
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(Int(appState.presentationDuration / 60))")
                                    .foregroundColor(PulseGridColors.accent)
                            }
                            
                            Slider(
                                value: $appState.presentationDuration,
                                in: 60...3600,
                                step: 60
                            )
                            .accentColor(PulseGridColors.accent)
                            
                            Toggle("Safe Screen Lock", isOn: $appState.safeScreenLock)
                                .toggleStyle(SwitchToggleStyle(tint: PulseGridColors.accent))
                                .foregroundColor(.white)
                            
                            Button("Start Presentation") {
                                appState.isPresentationMode = true
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(PulseGridColors.accent)
                            .cornerRadius(8)
                        }
                    }
                    
                    // External Display Section
                    UtilitySection(
                        title: "External Display",
                        subtitle: "Live reference preview on external screen",
                        icon: "tv"
                    ) {
                        VStack(spacing: 12) {
                            if let session = appState.externalDisplaySession, session.isActive {
                                VStack(spacing: 8) {
                                    HStack {
                                        Circle()
                                            .fill(PulseGridColors.accent)
                                            .frame(width: 8, height: 8)
                                        Text("External display active")
                                            .foregroundColor(PulseGridColors.accent)
                                        Spacer()
                                    }
                                    
                                    Text("Showing: \(session.mode.rawValue)")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                    
                                    Button("Stop External Display") {
                                        appState.stopExternalDisplay()
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(PulseGridColors.danger)
                                    .cornerRadius(8)
                                }
                            } else {
                                VStack(spacing: 12) {
                                    Text("External display support")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.subheadline)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Use AirPlay or wired connection to mirror visuals to external displays")
                                        .foregroundColor(.white.opacity(0.5))
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    
                    // Export Section
                    UtilitySection(
                        title: "Export Tools",
                        subtitle: "Export visuals for Instagram and other platforms",
                        icon: "square.and.arrow.up"
                    ) {
                        VStack(spacing: 12) {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(ExportFormat.allCases, id: \.rawValue) { format in
                                    Button(format.rawValue) {
                                        exportCurrent(format: format)
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(PulseGridColors.gold.opacity(0.8))
                                    .cornerRadius(8)
                                    .font(.caption)
                                }
                            }
                            
                            Button("Reel Background Generator") {
                                appState.showingExportDialog = true
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(PulseGridColors.accent)
                            .cornerRadius(8)
                        }
                    }
                    
                    // Color Scheme Manager Section
                    UtilitySection(
                        title: "Color Schemes",
                        subtitle: "Manage custom color palettes",
                        icon: "paintpalette"
                    ) {
                        VStack(spacing: 12) {
                            HStack {
                                Text("\(appState.customColorSchemes.count) schemes available")
                                    .foregroundColor(.white.opacity(0.7))
                                Spacer()
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(appState.customColorSchemes.prefix(3)) { scheme in
                                        VStack(spacing: 4) {
                                            HStack(spacing: 2) {
                                                Circle()
                                                    .fill(scheme.primary.color)
                                                    .frame(width: 12, height: 12)
                                                Circle()
                                                    .fill(scheme.secondary.color)
                                                    .frame(width: 12, height: 12)
                                                Circle()
                                                    .fill(scheme.accent.color)
                                                    .frame(width: 12, height: 12)
                                            }
                                            Text(scheme.name)
                                                .font(.caption2)
                                                .foregroundColor(.white)
                                        }
                                        .padding(8)
                                        .background(PulseGridColors.secondaryBackground)
                                        .cornerRadius(6)
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                            
                            Button("Manage Color Schemes") {
                                appState.showingColorSchemeManager = true
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(PulseGridColors.gold.opacity(0.8))
                            .cornerRadius(8)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
            .background(PulseGridColors.background)
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $appState.isPresentationMode) {
            PresentationModeView()
        }
        .sheet(isPresented: $appState.showingExportDialog) {
            ExportDialogView()
        }
        .sheet(isPresented: $appState.showingColorSchemeManager) {
            ColorSchemeManagerView()
        }
    }
    
    private func exportCurrent(format: ExportFormat) {
        // Simulate export functionality
        print("Exporting in format: \(format.rawValue)")
    }
}

struct UtilitySection<Content: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: 16) {
            // Section header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: icon)
                            .foregroundColor(PulseGridColors.accent)
                        Text(title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
            }
            
            // Section content
            content
        }
        .padding(20)
        .background(PulseGridColors.secondaryBackground)
        .cornerRadius(12)
    }
}

#Preview {
    UtilitiesView()
        .environmentObject(AppState())
} 