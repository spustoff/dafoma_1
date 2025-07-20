//
//  MoodboardSupportViews.swift
//  PulseGrid Studio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

// MARK: - Moodboard Creator View
struct MoodboardCreatorView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = "New Moodboard"
    @State private var selectedModes: [VisualMode] = []
    @State private var labels: [String] = ["", "", "", ""]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Create Moodboard")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Combine visual patterns into a reference layout")
                        .font(.subheadline)
                        .foregroundColor(PulseGridColors.gold)
                }
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Name input
                        VStack(spacing: 8) {
                            HStack {
                                Text("Moodboard Name")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            TextField("Enter name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Visual mode selection
                        VStack(spacing: 12) {
                            HStack {
                                Text("Select Visual Modes (1-4)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(selectedModes.count)/4")
                                    .foregroundColor(PulseGridColors.accent)
                            }
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(VisualMode.allCases) { mode in
                                    MoodboardModeCard(
                                        mode: mode,
                                        isSelected: selectedModes.contains(mode),
                                        canSelect: selectedModes.count < 4 || selectedModes.contains(mode)
                                    ) {
                                        toggleMode(mode)
                                    }
                                }
                            }
                        }
                        
                        // Labels for selected modes
                        if !selectedModes.isEmpty {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Labels")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                
                                ForEach(Array(selectedModes.enumerated()), id: \.offset) { index, mode in
                                    HStack {
                                        Image(systemName: mode.iconName)
                                            .foregroundColor(PulseGridColors.accent)
                                        
                                        Text(mode.rawValue)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        TextField("Label", text: $labels[index])
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(maxWidth: 120)
                                    }
                                }
                            }
                        }
                        
                        // Preview
                        if !selectedModes.isEmpty {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Preview")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                
                                MoodboardPreview(modes: selectedModes, labels: labels)
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
                        createMoodboard()
                    }
                    .foregroundColor(PulseGridColors.accent)
                    .disabled(selectedModes.isEmpty || name.isEmpty)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func toggleMode(_ mode: VisualMode) {
        if selectedModes.contains(mode) {
            selectedModes.removeAll { $0 == mode }
        } else if selectedModes.count < 4 {
            selectedModes.append(mode)
        }
    }
    
    private func createMoodboard() {
        let layouts = selectedModes.enumerated().map { index, mode in
            let position = calculatePosition(for: index, total: selectedModes.count)
            return Moodboard.MoodboardLayout(
                mode: mode,
                settings: appState.settingsFor(mode),
                label: labels[index].isEmpty ? mode.rawValue : labels[index],
                position: position
            )
        }
        
        let moodboard = Moodboard(name: name, layouts: layouts)
        appState.addMoodboard(moodboard)
        dismiss()
    }
    
    private func calculatePosition(for index: Int, total: Int) -> CGRect {
        let width: CGFloat = 1.0
        let height: CGFloat = 1.0
        
        switch total {
        case 1:
            return CGRect(x: 0, y: 0, width: width, height: height)
        case 2:
            return CGRect(
                x: index == 0 ? 0 : 0.5,
                y: 0,
                width: 0.5,
                height: height
            )
        case 3:
            if index == 0 {
                return CGRect(x: 0, y: 0, width: width, height: 0.5)
            } else {
                return CGRect(
                    x: index == 1 ? 0 : 0.5,
                    y: 0.5,
                    width: 0.5,
                    height: 0.5
                )
            }
        case 4:
            return CGRect(
                x: index % 2 == 0 ? 0 : 0.5,
                y: index < 2 ? 0 : 0.5,
                width: 0.5,
                height: 0.5
            )
        default:
            return CGRect(x: 0, y: 0, width: width, height: height)
        }
    }
}

// MARK: - Moodboard Mode Card
struct MoodboardModeCard: View {
    let mode: VisualMode
    let isSelected: Bool
    let canSelect: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: mode.iconName)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .white : (canSelect ? PulseGridColors.accent : .gray))
                
                Text(mode.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : (canSelect ? .white : .gray))
                    .multilineTextAlignment(.center)
            }
            .padding(12)
            .background(isSelected ? PulseGridColors.accent : PulseGridColors.secondaryBackground)
            .cornerRadius(8)
            .opacity(canSelect ? 1.0 : 0.5)
        }
        .disabled(!canSelect)
    }
}

// MARK: - Moodboard Preview
struct MoodboardPreview: View {
    let modes: [VisualMode]
    let labels: [String]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(PulseGridColors.secondaryBackground)
                .frame(height: 200)
            
            ForEach(Array(modes.enumerated()), id: \.offset) { index, mode in
                let position = previewPosition(for: index, total: modes.count)
                
                VStack(spacing: 4) {
                    Image(systemName: mode.iconName)
                        .font(.caption)
                        .foregroundColor(PulseGridColors.accent)
                    
                    Text(labels[index].isEmpty ? mode.rawValue : labels[index])
                        .font(.caption2)
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .padding(8)
                .background(Color.black.opacity(0.3))
                .cornerRadius(6)
                .position(x: position.x, y: position.y)
            }
        }
    }
    
    private func previewPosition(for index: Int, total: Int) -> CGPoint {
        let width: CGFloat = 300
        let height: CGFloat = 200
        
        switch total {
        case 1:
            return CGPoint(x: width/2, y: height/2)
        case 2:
            return CGPoint(
                x: index == 0 ? width/3 : 2*width/3,
                y: height/2
            )
        case 3:
            if index == 0 {
                return CGPoint(x: width/2, y: height/3)
            } else {
                return CGPoint(
                    x: index == 1 ? width/3 : 2*width/3,
                    y: 2*height/3
                )
            }
        case 4:
            return CGPoint(
                x: index % 2 == 0 ? width/3 : 2*width/3,
                y: index < 2 ? height/3 : 2*height/3
            )
        default:
            return CGPoint(x: width/2, y: height/2)
        }
    }
}

// MARK: - Moodboard Detail View
struct MoodboardDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let moodboard: Moodboard
    
    var body: some View {
        ZStack {
            PulseGridColors.background.ignoresSafeArea()
            
            VStack {
                // Header
                HStack {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(PulseGridColors.accent)
                    
                    Spacer()
                    
                    Text(moodboard.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Export") {
                        appState.showingExportDialog = true
                    }
                    .foregroundColor(PulseGridColors.gold)
                }
                .padding()
                
                // Moodboard content
                GeometryReader { geometry in
                    ZStack {
                        ForEach(moodboard.layouts) { layout in
                            let rect = CGRect(
                                x: layout.position.minX * geometry.size.width,
                                y: layout.position.minY * geometry.size.height,
                                width: layout.position.width * geometry.size.width,
                                height: layout.position.height * geometry.size.height
                            )
                            
                            ZStack {
                                // Background
                                Rectangle()
                                    .fill(layout.settings.colorOverlay.background.color)
                                
                                // Visual content placeholder
                                Image(systemName: layout.mode.iconName)
                                    .font(.largeTitle)
                                    .foregroundColor(layout.settings.colorOverlay.accent.color)
                                
                                // Label overlay
                                VStack {
                                    Spacer()
                                    HStack {
                                        Text(layout.label)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(Color.black.opacity(0.7))
                                            .cornerRadius(6)
                                        Spacer()
                                    }
                                    .padding(8)
                                }
                            }
                            .frame(width: rect.width, height: rect.height)
                            .position(x: rect.midX, y: rect.midY)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $appState.showingExportDialog) {
            ExportDialogView()
        }
    }
}

// MARK: - External Display View
struct ExternalDisplayView: View {
    @EnvironmentObject var appState: AppState
    let session: ExternalDisplaySession
    
    var body: some View {
        ZStack {
            session.settings.colorOverlay.background.color.ignoresSafeArea()
            
            // Visual content
            switch session.mode {
            case .signalMesh:
                EnhancedSignalMeshView(settings: session.settings)
            case .magneticField:
                EnhancedMagneticFieldView(settings: session.settings)
            case .heatPulse:
                EnhancedHeatPulseView(settings: session.settings)
            case .stressWave:
                EnhancedStressWaveView(settings: session.settings)
            case .neuroSpark:
                EnhancedNeuroSparkView(settings: session.settings)
            }
        }
    }
}

#Preview("Moodboard Creator") {
    MoodboardCreatorView()
        .environmentObject(AppState())
}

#Preview("Moodboard Detail") {
    MoodboardDetailView(moodboard: Moodboard(name: "Test Board", layouts: []))
        .environmentObject(AppState())
} 