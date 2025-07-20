//
//  PresentationModeView.swift
//  PulseGrid Studio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct PresentationModeView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var timeRemaining: Double = 0
    @State private var timer: Timer?
    @State private var showExitHint = true
    
    var body: some View {
        ZStack {
            // Background
            appState.settingsFor(appState.currentMode).colorOverlay.background.color
                .ignoresSafeArea()
            
            // Visual content
            visualContent
                .ignoresSafeArea()
            
            // Exit hint (appears briefly)
            if showExitHint {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Text("Presentation Mode")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Tap anywhere to exit")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            if timeRemaining > 0 {
                                Text("\(Int(timeRemaining / 60)):\(String(format: "%02d", Int(timeRemaining) % 60))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(PulseGridColors.accent)
                            }
                        }
                        .padding(20)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                        Spacer()
                    }
                    .padding(.bottom, 50)
                }
                .transition(.opacity)
            }
        }
        .onTapGesture {
            exitPresentationMode()
        }
        .onAppear {
            startPresentationMode()
        }
        .onDisappear {
            stopTimer()
        }
        // Prevent screen dimming if safe screen lock is enabled
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            if appState.safeScreenLock {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
    
    @ViewBuilder
    private var visualContent: some View {
        let currentSettings = appState.settingsFor(appState.currentMode)
        
        switch appState.currentMode {
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
    
    private func startPresentationMode() {
        timeRemaining = appState.presentationDuration
        
        // Disable screen dimming if safe screen lock is enabled
        if appState.safeScreenLock {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        
        // Show exit hint briefly
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showExitHint = false
            }
        }
        
        // Start countdown timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                exitPresentationMode()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        // Re-enable screen dimming
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func exitPresentationMode() {
        stopTimer()
        appState.isPresentationMode = false
        dismiss()
    }
}

#Preview {
    PresentationModeView()
        .environmentObject(AppState())
} 