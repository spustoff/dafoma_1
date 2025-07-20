//
//  VisualDisplayView.swift
//  PulseGrid
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct VisualDisplayView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let mode: VisualMode
    @State private var showControls = true
    @State private var controlsTimer: Timer?
    @State private var showExportSuccess = false
    
    var body: some View {
        ZStack {
            // Background
            PulseGridColors.background.ignoresSafeArea()
            
            // Visual Animation
            visualContent
                .ignoresSafeArea()
                .onTapGesture {
                    toggleControls()
                }
            
            // Controls Overlay
            if showControls {
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
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                    
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
            hideControlsAfterDelay()
        }
    }
    
    @ViewBuilder
    private var visualContent: some View {
        switch mode {
        case .signalMesh:
            SignalMeshView()
        case .magneticField:
            MagneticFieldView()
        case .heatPulse:
            HeatPulseView()
        case .stressWave:
            StressWaveView()
        case .neuroSpark:
            NeuroSparkView()
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
    VisualDisplayView(mode: .signalMesh)
        .environmentObject(AppState())
} 