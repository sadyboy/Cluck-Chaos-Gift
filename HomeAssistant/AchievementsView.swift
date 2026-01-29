import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var userDefaults: UserDefaultsManager
    @StateObject private var viewModel = AchievementsViewModel()
    @State private var selectedRarity: AchievementRarity?
    
    var achievements: [Achievement] {
        viewModel.getAchievements(
            unlockedIds: userDefaults.unlockedAchievements,
            totalPoints: userDefaults.totalPoints,
            eventCount: userDefaults.events.count
        )
    }
    
    var filteredAchievements: [Achievement] {
        if let rarity = selectedRarity {
            return achievements.filter { $0.rarity == rarity }
        }
        return achievements
    }
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                HStack {
                    Text("Achievements")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, Color(hex: "C7D2FE")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "F59E0B").opacity(0.3), Color(hex: "FCD34D").opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                        
                        Text("\(userDefaults.unlockedAchievements.count)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(title: "All", isSelected: selectedRarity == nil) {
                            selectedRarity = nil
                        }
                        
                        ForEach(AchievementRarity.allCases, id: \.self) { rarity in
                            RarityFilterChip(rarity: rarity, isSelected: selectedRarity == rarity) {
                                selectedRarity = rarity
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredAchievements) { achievement in
                            AchievementCard(achievement: achievement)
                        }
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
            }
        }
        .background(
            DarkNeonBackgroundView()
        )
    }
}

struct RarityFilterChip: View {
    let rarity: AchievementRarity
    var isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(rarity.rawValue)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? rarity.color : LinearGradient(colors: [Color.white.opacity(0.1)], startPoint: .leading, endPoint: .trailing))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(isSelected ? 0.4 : 0.2), lineWidth: 1)
                        )
                )
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    @State private var appeared = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(achievement.isUnlocked ? 0.12 : 0.06), Color.white.opacity(achievement.isUnlocked ? 0.08 : 0.03)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            achievement.isUnlocked ? achievement.rarity.color : LinearGradient(colors: [Color.white.opacity(0.2)], startPoint: .leading, endPoint: .trailing),
                            lineWidth: achievement.isUnlocked ? 2 : 1
                        )
                )
            
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(achievement.isUnlocked ? achievement.rarity.color : LinearGradient(colors: [Color.white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: achievement.icon)
                        .font(.system(size: 36))
                        .foregroundColor(achievement.isUnlocked ? .white : .white.opacity(0.3))
                    
                    if !achievement.isUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.5))
                            .offset(x: 25, y: 25)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(achievement.rarity.rawValue)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(achievement.rarity.color)
                            )
                        
                        Spacer()
                    }
                    
                    Text(achievement.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(achievement.isUnlocked ? .white : .white.opacity(0.5))
                    
                    Text(achievement.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(2)
                    
                    if !achievement.isUnlocked && achievement.progress > 0 {
                        VStack(alignment: .leading, spacing: 4) {
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white.opacity(0.2))
                                        .frame(height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(achievement.rarity.color)
                                        .frame(width: geometry.size.width * achievement.progress, height: 8)
                                }
                            }
                            .frame(height: 8)
                            
                            Text("\(Int(achievement.progress * 100))%")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
                
                Spacer()
            }
            .padding(20)
        }
        .scaleEffect(appeared ? 1 : 0.9)
        .opacity(appeared ? 1 : 0)
        .rotation3DEffect(
            .degrees(appeared ? 0 : 10),
            axis: (x: 1, y: 0, z: 0)
        )
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double.random(in: 0...0.2))) {
                appeared = true
            }
        }
    }
}
