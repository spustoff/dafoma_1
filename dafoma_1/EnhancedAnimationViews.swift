//
//  EnhancedAnimationViews.swift
//  PulseGrid Studio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

// MARK: - Enhanced Signal Mesh View
struct EnhancedSignalMeshView: View {
    @EnvironmentObject var appState: AppState
    let settings: VisualSettings
    @State private var phase: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<8, id: \.self) { row in
                    ForEach(0..<6, id: \.self) { col in
                        let x = geometry.size.width / 5 * Double(col)
                        let y = geometry.size.height / 7 * Double(row)
                        
                        // Vertical lines
                        Rectangle()
                            .fill(settings.colorOverlay.accent.color.opacity(0.3 + 0.7 * sin(phase + Double(col) * 0.5) * settings.brightness))
                            .frame(width: settings.lineWidth, height: geometry.size.height)
                            .position(x: x, y: geometry.size.height / 2)
                        
                        // Horizontal lines
                        Rectangle()
                            .fill(settings.colorOverlay.accent.color.opacity(0.3 + 0.7 * sin(phase + Double(row) * 0.5) * settings.brightness))
                            .frame(width: geometry.size.width, height: settings.lineWidth)
                            .position(x: geometry.size.width / 2, y: y)
                        
                        // Intersection nodes
                        Circle()
                            .fill(settings.colorOverlay.secondary.color)
                            .frame(width: 8, height: 8)
                            .opacity((0.5 + 0.5 * sin(phase + Double(row + col) * 0.3)) * settings.brightness)
                            .scaleEffect(1 + 0.5 * sin(phase + Double(row + col) * 0.2))
                            .position(x: x, y: y)
                    }
                }
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if !appState.isAnimationRunning {
                return
            }
            
            withAnimation(.linear(duration: 0.05)) {
                phase += 0.1 * appState.animationIntensity * settings.speed
            }
        }
    }
}

// MARK: - Enhanced Magnetic Field View
struct EnhancedMagneticFieldView: View {
    @EnvironmentObject var appState: AppState
    let settings: VisualSettings
    @State private var particles: [Particle] = []
    @State private var time: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles, id: \.id) { particle in
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    settings.colorOverlay.primary.color.opacity(0.8 * settings.brightness),
                                    settings.colorOverlay.secondary.color.opacity(0.4 * settings.brightness)
                                ]),
                                center: .center,
                                startRadius: 1,
                                endRadius: particle.size
                            )
                        )
                        .frame(width: particle.size, height: particle.size)
                        .position(x: particle.x, y: particle.y)
                        .opacity(particle.opacity * settings.brightness)
                }
            }
        }
        .onAppear {
            setupParticles()
            startAnimation()
        }
    }
    
    private func setupParticles() {
        particles = (0..<50).map { _ in
            Particle(
                id: UUID(),
                x: Double.random(in: 0...UIScreen.main.bounds.width),
                y: Double.random(in: 0...UIScreen.main.bounds.height),
                angle: Double.random(in: 0...2 * .pi),
                speed: Double.random(in: 1...3),
                size: Double.random(in: 4...12),
                opacity: Double.random(in: 0.3...0.8)
            )
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if !appState.isAnimationRunning {
                return
            }
            
            time += 0.05 * appState.animationIntensity * settings.speed
            
            for i in particles.indices {
                let centerX = UIScreen.main.bounds.width / 2
                let centerY = UIScreen.main.bounds.height / 2
                
                let radius = sqrt(pow(particles[i].x - centerX, 2) + pow(particles[i].y - centerY, 2))
                let magneticForce = 200.0 / (radius + 1)
                
                particles[i].angle += magneticForce * 0.01 * appState.animationIntensity * settings.speed
                particles[i].x += cos(particles[i].angle) * particles[i].speed * appState.animationIntensity * settings.speed
                particles[i].y += sin(particles[i].angle) * particles[i].speed * appState.animationIntensity * settings.speed
                
                // Wrap around edges
                if particles[i].x < 0 { particles[i].x = UIScreen.main.bounds.width }
                if particles[i].x > UIScreen.main.bounds.width { particles[i].x = 0 }
                if particles[i].y < 0 { particles[i].y = UIScreen.main.bounds.height }
                if particles[i].y > UIScreen.main.bounds.height { particles[i].y = 0 }
                
                // Pulse opacity
                particles[i].opacity = 0.3 + 0.5 * sin(time + Double(i) * 0.1)
            }
        }
    }
}

// MARK: - Enhanced Heat Pulse View
struct EnhancedHeatPulseView: View {
    @EnvironmentObject var appState: AppState
    let settings: VisualSettings
    @State private var pulsePhase: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    settings.colorOverlay.secondary.color.opacity(0.6 * settings.brightness),
                                    settings.colorOverlay.accent.color.opacity(0.3 * settings.brightness),
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 200 + Double(index) * 50
                            )
                        )
                        .scaleEffect(0.5 + 0.5 * sin(pulsePhase - Double(index) * 0.5))
                        .opacity((0.3 + 0.4 * sin(pulsePhase - Double(index) * 0.3)) * settings.brightness)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if !appState.isAnimationRunning {
                return
            }
            
            withAnimation(.linear(duration: 0.1)) {
                pulsePhase += 0.05 * appState.animationIntensity * settings.speed
            }
        }
    }
}

// MARK: - Enhanced Stress Wave View
struct EnhancedStressWaveView: View {
    @EnvironmentObject var appState: AppState
    let settings: VisualSettings
    @State private var wavePhase: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<20, id: \.self) { index in
                    let y = geometry.size.height / 19 * Double(index)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        
                        for x in stride(from: 0, through: geometry.size.width, by: 4) {
                            let distortion = sin(wavePhase + Double(x) * 0.02 + Double(index) * 0.1) * 20 * appState.animationIntensity * settings.speed
                            path.addLine(to: CGPoint(x: x, y: y + distortion))
                        }
                    }
                    .stroke(
                        settings.colorOverlay.primary.color.opacity((0.4 + 0.6 * sin(wavePhase + Double(index) * 0.1)) * settings.brightness),
                        lineWidth: settings.lineWidth
                    )
                }
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if !appState.isAnimationRunning {
                return
            }
            
            withAnimation(.linear(duration: 0.05)) {
                wavePhase += 0.1 * appState.animationIntensity * settings.speed
            }
        }
    }
}

// MARK: - Enhanced Neuro Spark View
struct EnhancedNeuroSparkView: View {
    @EnvironmentObject var appState: AppState
    let settings: VisualSettings
    @State private var nodes: [Node] = []
    @State private var connections: [Connection] = []
    @State private var sparkPhase: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Connections
                ForEach(connections, id: \.id) { connection in
                    if let startNode = nodes.first(where: { $0.id == connection.startNodeId }),
                       let endNode = nodes.first(where: { $0.id == connection.endNodeId }) {
                        
                        Path { path in
                            path.move(to: CGPoint(x: startNode.x, y: startNode.y))
                            path.addLine(to: CGPoint(x: endNode.x, y: endNode.y))
                        }
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    settings.colorOverlay.primary.color.opacity(connection.intensity * settings.brightness),
                                    settings.colorOverlay.accent.color.opacity(connection.intensity * 0.8 * settings.brightness)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: settings.lineWidth
                        )
                        .opacity(connection.opacity * settings.brightness)
                    }
                }
                
                // Nodes
                ForEach(nodes, id: \.id) { node in
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    settings.colorOverlay.accent.color,
                                    settings.colorOverlay.primary.color.opacity(0.6),
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: 0,
                                endRadius: node.size
                            )
                        )
                        .frame(width: node.size * 2, height: node.size * 2)
                        .position(x: node.x, y: node.y)
                        .opacity(node.opacity * settings.brightness)
                        .scaleEffect(node.scale)
                }
            }
        }
        .onAppear {
            setupNodes()
            startAnimation()
        }
    }
    
    private func setupNodes() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        nodes = (0..<15).map { _ in
            Node(
                id: UUID(),
                x: Double.random(in: 50...screenWidth - 50),
                y: Double.random(in: 100...screenHeight - 100),
                size: Double.random(in: 8...16),
                opacity: Double.random(in: 0.5...1.0),
                scale: 1.0
            )
        }
        
        // Create random connections
        connections = []
        for _ in 0..<20 {
            let startNode = nodes.randomElement()!
            let endNode = nodes.randomElement()!
            
            if startNode.id != endNode.id {
                connections.append(Connection(
                    id: UUID(),
                    startNodeId: startNode.id,
                    endNodeId: endNode.id,
                    intensity: Double.random(in: 0.3...0.8),
                    opacity: Double.random(in: 0.2...0.6)
                ))
            }
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if !appState.isAnimationRunning {
                return
            }
            
            sparkPhase += 0.1 * appState.animationIntensity * settings.speed
            
            // Animate nodes
            for i in nodes.indices {
                nodes[i].opacity = 0.5 + 0.5 * sin(sparkPhase + Double(i) * 0.2)
                nodes[i].scale = 0.8 + 0.4 * sin(sparkPhase + Double(i) * 0.15)
            }
            
            // Animate connections
            for i in connections.indices {
                connections[i].opacity = 0.2 + 0.4 * sin(sparkPhase + Double(i) * 0.3)
                connections[i].intensity = 0.3 + 0.5 * sin(sparkPhase + Double(i) * 0.25)
            }
        }
    }
}

#Preview("Enhanced Signal Mesh") {
    EnhancedSignalMeshView(settings: .default)
        .environmentObject(AppState())
}

#Preview("Enhanced Magnetic Field") {
    EnhancedMagneticFieldView(settings: .default)
        .environmentObject(AppState())
} 