//
//  ExportDialogView.swift
//  PulseGrid Studio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct ExportDialogView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedFormat: ExportFormat = .instagram
    @State private var includeTextOverlay = true
    @State private var overlayOpacity: Double = 0.5
    @State private var selectedMode: VisualMode = .signalMesh
    @State private var exportInProgress = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Export Visual")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Export high-energy patterns for professional use")
                        .font(.subheadline)
                        .foregroundColor(PulseGridColors.gold)
                }
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Format Selection
                        VStack(spacing: 12) {
                            HStack {
                                Text("Export Format")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(ExportFormat.allCases, id: \.rawValue) { format in
                                    ExportFormatCard(
                                        format: format,
                                        isSelected: selectedFormat == format
                                    ) {
                                        selectedFormat = format
                                    }
                                }
                            }
                        }
                        
                        // Visual Mode Selection
                        VStack(spacing: 12) {
                            HStack {
                                Text("Visual Pattern")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(VisualMode.allCases) { mode in
                                        VisualModeChip(
                                            mode: mode,
                                            isSelected: selectedMode == mode
                                        ) {
                                            selectedMode = mode
                                        }
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                        
                        // Preview
                        VStack(spacing: 12) {
                            HStack {
                                Text("Preview")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(appState.settingsFor(selectedMode).colorOverlay.background.color)
                                    .aspectRatio(selectedFormat.aspectRatio, contentMode: .fit)
                                    .frame(maxHeight: 200)
                                
                                // Simulated visual pattern
                                Image(systemName: selectedMode.iconName)
                                    .font(.system(size: 40))
                                    .foregroundColor(appState.settingsFor(selectedMode).colorOverlay.accent.color)
                                
                                if includeTextOverlay {
                                    VStack {
                                        Spacer()
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Place Text Here")
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                                Text("Edit in your story editor")
                                                    .font(.caption)
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                            Spacer()
                                        }
                                        .padding(16)
                                        .background(Color.black.opacity(overlayOpacity))
                                        .cornerRadius(8)
                                        .padding(20)
                                    }
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(PulseGridColors.accent.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        // Overlay Options
                        if selectedFormat == .instagram {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Story Options")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                
                                Toggle("Include Text Overlay", isOn: $includeTextOverlay)
                                    .toggleStyle(SwitchToggleStyle(tint: PulseGridColors.accent))
                                    .foregroundColor(.white)
                                
                                if includeTextOverlay {
                                    VStack(spacing: 8) {
                                        HStack {
                                            Text("Overlay Opacity")
                                                .foregroundColor(.white)
                                            Spacer()
                                            Text("\(Int(overlayOpacity * 100))%")
                                                .foregroundColor(PulseGridColors.accent)
                                        }
                                        
                                        Slider(value: $overlayOpacity, in: 0.2...0.8)
                                            .accentColor(PulseGridColors.accent)
                                    }
                                }
                            }
                            .padding(16)
                            .background(PulseGridColors.secondaryBackground)
                            .cornerRadius(12)
                        }
                        
                        // Export Button
                        Button(action: {
                            exportImage()
                        }) {
                            HStack {
                                if exportInProgress {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.title2)
                                }
                                
                                Text(exportInProgress ? "Exporting..." : "Export Image")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(exportInProgress ? PulseGridColors.accent.opacity(0.6) : PulseGridColors.accent)
                            .cornerRadius(12)
                        }
                        .disabled(exportInProgress)
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
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func exportImage() {
        exportInProgress = true
        
        // Simulate export process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            exportInProgress = false
            
            // Show success message
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                dismiss()
            }
        }
    }
}

struct ExportFormatCard: View {
    let format: ExportFormat
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Aspect ratio preview
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? PulseGridColors.accent : PulseGridColors.background)
                    .aspectRatio(format.aspectRatio, contentMode: .fit)
                    .frame(height: 40)
                
                Text(format.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(12)
            .background(PulseGridColors.secondaryBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? PulseGridColors.accent : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct VisualModeChip: View {
    let mode: VisualMode
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: mode.iconName)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : PulseGridColors.accent)
                
                Text(mode.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : PulseGridColors.accent)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? PulseGridColors.accent : PulseGridColors.secondaryBackground)
            .cornerRadius(20)
        }
    }
}

#Preview {
    ExportDialogView()
        .environmentObject(AppState())
} 