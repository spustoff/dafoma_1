//
//  MoodboardView.swift
//  PulseGrid Studio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct MoodboardView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingCreator = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Moodboards")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Create visual collages for reference")
                            .font(.subheadline)
                            .foregroundColor(PulseGridColors.gold)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingCreator = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(PulseGridColors.accent)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                if appState.moodboards.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "rectangle.grid.2x2")
                            .font(.system(size: 60))
                            .foregroundColor(PulseGridColors.accent.opacity(0.6))
                        
                        Text("No Moodboards Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Create your first moodboard to combine multiple high-energy patterns into a single technical reference layout")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button("Create Moodboard") {
                            showingCreator = true
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(PulseGridColors.accent)
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Moodboard grid
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(appState.moodboards) { moodboard in
                                MoodboardCard(moodboard: moodboard)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                Spacer()
            }
            .background(PulseGridColors.background)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingCreator) {
            MoodboardCreatorView()
        }
    }
}

struct MoodboardCard: View {
    @EnvironmentObject var appState: AppState
    let moodboard: Moodboard
    @State private var showingDetail = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Preview
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(PulseGridColors.secondaryBackground)
                    .frame(height: 120)
                
                // Mini layout preview
                ForEach(Array(moodboard.layouts.prefix(4).enumerated()), id: \.offset) { index, layout in
                    let position = previewPosition(for: index, total: moodboard.layouts.count)
                    
                    VStack(spacing: 2) {
                        Image(systemName: layout.mode.iconName)
                            .font(.caption)
                            .foregroundColor(layout.settings.colorOverlay.primary.color)
                        
                        Text(layout.label)
                            .font(.caption2)
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                    .padding(4)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(4)
                    .position(x: position.x, y: position.y)
                }
            }
            
            // Title and metadata
            VStack(spacing: 4) {
                Text(moodboard.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("\(moodboard.layouts.count) pattern\(moodboard.layouts.count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Actions
            HStack {
                Button("View") {
                    showingDetail = true
                }
                .font(.caption)
                .foregroundColor(PulseGridColors.accent)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(PulseGridColors.accent.opacity(0.2))
                .cornerRadius(6)
                
                Spacer()
                
                Button("Export") {
                    appState.showingExportDialog = true
                }
                .font(.caption)
                .foregroundColor(PulseGridColors.gold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(PulseGridColors.gold.opacity(0.2))
                .cornerRadius(6)
            }
        }
        .padding(16)
        .background(PulseGridColors.secondaryBackground)
        .cornerRadius(12)
        .onTapGesture {
            showingDetail = true
        }
        .fullScreenCover(isPresented: $showingDetail) {
            MoodboardDetailView(moodboard: moodboard)
        }
    }
    
    private func previewPosition(for index: Int, total: Int) -> CGPoint {
        let width: CGFloat = 120
        let height: CGFloat = 120
        
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

#Preview {
    MoodboardView()
        .environmentObject(AppState())
} 