import Foundation

class AchievementsViewModel: ObservableObject {
    static let allAchievements: [Achievement] = [
        Achievement(title: "First Steps", description: "Complete 10 events", rarity: .common, icon: "flag.fill"),
        Achievement(title: "Energy Saver", description: "Save 100 kWh", rarity: .common, icon: "leaf.fill"),
        Achievement(title: "Water Guardian", description: "Monitor water 20 times", rarity: .common, icon: "drop.fill"),
        Achievement(title: "Point Collector", description: "Earn 1000 points", rarity: .rare, icon: "star.fill"),
        Achievement(title: "Security Pro", description: "Check security 30 times", rarity: .rare, icon: "checkmark.shield.fill"),
        Achievement(title: "Climate Master", description: "Optimize climate 25 times", rarity: .rare, icon: "sun.max.fill"),
        Achievement(title: "Automation Expert", description: "Complete 50 events", rarity: .rare, icon: "cpu.fill"),
        Achievement(title: "Home Commander", description: "Reach 5000 points", rarity: .epic, icon: "house.fill"),
        Achievement(title: "Efficiency King", description: "100 consecutive days", rarity: .epic, icon: "crown.fill"),
        Achievement(title: "Eco Warrior", description: "Save 1000 kWh", rarity: .epic, icon: "globe.americas.fill"),
        Achievement(title: "Smart Living", description: "Complete all categories", rarity: .epic, icon: "sparkles"),
        Achievement(title: "Ultimate Master", description: "Reach 10000 points", rarity: .legendary, icon: "trophy.fill"),
        Achievement(title: "Legendary Guardian", description: "365 day streak", rarity: .legendary, icon: "flame.fill"),
        Achievement(title: "Infinity Achievement", description: "Unlock all achievements", rarity: .legendary, icon: "infinity")
    ]
    
    func getAchievements(unlockedIds: Set<UUID>, totalPoints: Int, eventCount: Int) -> [Achievement] {
        var achievements = AchievementsViewModel.allAchievements
        
        for i in 0..<achievements.count {
            if unlockedIds.contains(achievements[i].id) {
                achievements[i].isUnlocked = true
                achievements[i].progress = 1.0
            } else {
                achievements[i].progress = calculateProgress(for: achievements[i], totalPoints: totalPoints, eventCount: eventCount)
            }
        }
        
        return achievements
    }
    
    private func calculateProgress(for achievement: Achievement, totalPoints: Int, eventCount: Int) -> Double {
        switch achievement.title {
        case "First Steps":
            return min(Double(eventCount) / 10.0, 1.0)
        case "Point Collector":
            return min(Double(totalPoints) / 1000.0, 1.0)
        case "Automation Expert":
            return min(Double(eventCount) / 50.0, 1.0)
        case "Home Commander":
            return min(Double(totalPoints) / 5000.0, 1.0)
        case "Ultimate Master":
            return min(Double(totalPoints) / 10000.0, 1.0)
        default:
            return 0.0
        }
    }
}
