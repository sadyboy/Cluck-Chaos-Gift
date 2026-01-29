import Foundation
import SwiftUI

struct Event: Identifiable, Codable {
    let id: UUID
    var title: String
    var category: EventCategory
    var timestamp: Date
    var value: Int
    
    init(id: UUID = UUID(), title: String, category: EventCategory, timestamp: Date = Date(), value: Int) {
        self.id = id
        self.title = title
        self.category = category
        self.timestamp = timestamp
        self.value = value
    }
}

enum EventCategory: String, Codable, CaseIterable {
    case energy = "Energy"
    case water = "Water"
    case security = "Security"
    case climate = "Climate"
    case automation = "Automation"
    
    var color: Color {
        switch self {
        case .energy: return Color(hex: "FFD700")
        case .water: return Color(hex: "00CED1")
        case .security: return Color(hex: "FF6B6B")
        case .climate: return Color(hex: "98D8C8")
        case .automation: return Color(hex: "A78BFA")
        }
    }
    
    var icon: String {
        switch self {
        case .energy: return "bolt.fill"
        case .water: return "drop.fill"
        case .security: return "lock.shield.fill"
        case .climate: return "thermometer.sun.fill"
        case .automation: return "gearshape.2.fill"
        }
    }
}

struct Achievement: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let rarity: AchievementRarity
    let icon: String
    var isUnlocked: Bool
    var progress: Double
    
    init(id: UUID = UUID(), title: String, description: String, rarity: AchievementRarity, icon: String, isUnlocked: Bool = false, progress: Double = 0.0) {
        self.id = id
        self.title = title
        self.description = description
        self.rarity = rarity
        self.icon = icon
        self.isUnlocked = isUnlocked
        self.progress = progress
    }
}

enum AchievementRarity: String, CaseIterable {
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    
    var color: LinearGradient {
        switch self {
        case .common:
            return LinearGradient(colors: [Color(hex: "6B7280"), Color(hex: "9CA3AF")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .rare:
            return LinearGradient(colors: [Color(hex: "3B82F6"), Color(hex: "60A5FA")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .epic:
            return LinearGradient(colors: [Color(hex: "A855F7"), Color(hex: "C084FC")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .legendary:
            return LinearGradient(colors: [Color(hex: "F59E0B"), Color(hex: "FCD34D"), Color(hex: "F59E0B")], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

struct UserProfile: Codable {
    var name: String
    var photoData: Data?
}

struct StatisticsData: Identifiable {
    let id = UUID()
    let category: EventCategory
    let value: Double
    let trend: Double
}
