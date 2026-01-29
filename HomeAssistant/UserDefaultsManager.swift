import Foundation
import SwiftUI

class UserDefaultsManager: ObservableObject {
    @Published var userName: String {
        didSet {
            UserDefaults.standard.set(userName, forKey: "userName")
        }
    }
    
    @Published var userPhotoData: Data? {
        didSet {
            UserDefaults.standard.set(userPhotoData, forKey: "userPhotoData")
        }
    }
    
    @Published var events: [Event] {
        didSet {
            if let encoded = try? JSONEncoder().encode(events) {
                UserDefaults.standard.set(encoded, forKey: "events")
            }
        }
    }
    
    @Published var unlockedAchievements: Set<UUID> {
        didSet {
            let stringArray = unlockedAchievements.map { $0.uuidString }
            UserDefaults.standard.set(stringArray, forKey: "unlockedAchievements")
        }
    }
    
    @Published var totalPoints: Int {
        didSet {
            UserDefaults.standard.set(totalPoints, forKey: "totalPoints")
        }
    }
    
    init() {
        self.userName = UserDefaults.standard.string(forKey: "userName") ?? "User"
        self.userPhotoData = UserDefaults.standard.data(forKey: "userPhotoData")
        
        if let eventsData = UserDefaults.standard.data(forKey: "events"),
           let decoded = try? JSONDecoder().decode([Event].self, from: eventsData) {
            self.events = decoded
        } else {
            self.events = []
        }
        
        if let stringArray = UserDefaults.standard.array(forKey: "unlockedAchievements") as? [String] {
            self.unlockedAchievements = Set(stringArray.compactMap { UUID(uuidString: $0) })
        } else {
            self.unlockedAchievements = Set()
        }
        
        self.totalPoints = UserDefaults.standard.integer(forKey: "totalPoints")
    }
    
    func addEvent(_ event: Event) {
        events.insert(event, at: 0)
        totalPoints += event.value
        checkAchievements()
    }
    
    func checkAchievements() {
        if events.count >= 10 && !unlockedAchievements.contains(AchievementsViewModel.allAchievements[0].id) {
            unlockedAchievements.insert(AchievementsViewModel.allAchievements[0].id)
        }
        if totalPoints >= 1000 && !unlockedAchievements.contains(AchievementsViewModel.allAchievements[3].id) {
            unlockedAchievements.insert(AchievementsViewModel.allAchievements[3].id)
        }
        if events.count >= 50 && !unlockedAchievements.contains(AchievementsViewModel.allAchievements[6].id) {
            unlockedAchievements.insert(AchievementsViewModel.allAchievements[6].id)
        }
    }
}
