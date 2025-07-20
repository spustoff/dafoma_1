//
//  EnhancedVisualDisplayView.swift
//  PulseGrid Studio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct EnhancedVisualDisplayView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let mode: VisualMode
    @State private var showControls = true
    @State private var controlsTimer: Timer?
    @State private var showExportSuccess = false
    @State private var showingSettings = false
    @State private var currentSettings: VisualSettings
    
    init(mode: VisualMode) {
        self.mode = mode
        self._currentSettings = State(initialValue: .default)
    }
    
    var body: some View {
        ZStack {
            // Background
            currentSettings.colorOverlay.background.color.ignoresSafeArea()
            
            // Visual Animation
            visualContent
                .ignoresSafeArea()
                .onTapGesture {
                    toggleControls()
                }
            
            // Controls Overlay
            if showControls && !appState.isPresentationMode {
                VStack {
                    // Top Controls
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Text(mode.rawValue)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(20)
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Button(action: {
                                showingSettings = true
                            }) {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            
                            Button(action: {
                                appState.toggleFavorite(mode)
                            }) {
                                Image(systemName: appState.isFavorite(mode) ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .foregroundColor(appState.isFavorite(mode) ? PulseGridColors.danger : .white)
                                    .padding(12)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Quick Settings
                    VStack(spacing: 12) {
                        HStack {
                            Text("Speed")
                                .foregroundColor(.white)
                            Slider(value: $currentSettings.speed, in: 0.1...2.0)
                                .accentColor(currentSettings.colorOverlay.accent.color)
                            Text("\(Int(currentSettings.speed * 100))%")
                                .foregroundColor(.white)
                                .frame(width: 40)
                        }
                        
                        HStack {
                            Text("Brightness")
                                .foregroundColor(.white)
                            Slider(value: $currentSettings.brightness, in: 0.1...1.0)
                                .accentColor(currentSettings.colorOverlay.accent.color)
                            Text("\(Int(currentSettings.brightness * 100))%")
                                .foregroundColor(.white)
                                .frame(width: 40)
                        }
                    }
                    .padding(16)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    
                    // Bottom Controls
                    HStack(spacing: 20) {
                        Button(action: exportImage) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(PulseGridColors.accent.opacity(0.8))
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            appState.isAnimationRunning.toggle()
                        }) {
                            Image(systemName: appState.isAnimationRunning ? "pause.fill" : "play.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(PulseGridColors.gold.opacity(0.8))
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            appState.isPresentationMode = true
                        }) {
                            Image(systemName: "play.display")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(PulseGridColors.danger.opacity(0.8))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.bottom, 40)
                }
                .transition(.opacity)
            }
            
            // Export Success Message
            if showExportSuccess {
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(PulseGridColors.accent)
                    Text("Frame Exported")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding(20)
                .background(Color.black.opacity(0.8))
                .cornerRadius(12)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .onAppear {
            currentSettings = appState.settingsFor(mode)
            hideControlsAfterDelay()
        }
        .onChange(of: currentSettings) { newSettings in
            appState.updateSettings(for: mode, settings: newSettings)
        }
        .sheet(isPresented: $showingSettings) {
            VisualSettingsView(mode: mode, settings: $currentSettings)
        }
        .fullScreenCover(isPresented: $appState.isPresentationMode) {
            PresentationModeView()
        }
    }
    
    @ViewBuilder
    private var visualContent: some View {
        switch mode {
        case .signalMesh:
            EnhancedSignalMeshView(settings: currentSettings)
        case .magneticField:
            EnhancedMagneticFieldView(settings: currentSettings)
        case .heatPulse:
            EnhancedHeatPulseView(settings: currentSettings)
        case .stressWave:
            EnhancedStressWaveView(settings: currentSettings)
        case .neuroSpark:
            EnhancedNeuroSparkView(settings: currentSettings)
        }
    }
    
    private func toggleControls() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showControls.toggle()
        }
        
        if showControls {
            hideControlsAfterDelay()
        }
    }
    
    private func hideControlsAfterDelay() {
        controlsTimer?.invalidate()
        controlsTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                showControls = false
            }
        }
    }
    
    private func exportImage() {
        // Simulate export functionality
        withAnimation(.spring()) {
            showExportSuccess = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showExportSuccess = false
            }
        }
    }
}

#Preview {
    EnhancedVisualDisplayView(mode: .signalMesh)
        .environmentObject(AppState())
} 