import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userDefaults: UserDefaultsManager
    @Binding var showingSettings: Bool
    @State private var showingAddEvent = false
    @State private var animateGradient = false
    @State private var showCelebration = false
    @State private var currentStreak = 7
    @State private var dailyGoal = 500
    @State private var todayPoints = 0
    @State private var showDailyTask = false
    @State private var completedDailyTasks: Set<String> = []
    @State private var navigateToTimeline = false
    @State private var navigateToAchievements = false
    
    var dailyProgress: Double {
        min(Double(todayPoints) / Double(dailyGoal), 1.0)
    }
    
    var nextAchievement: Achievement? {
        let viewModel = AchievementsViewModel()
        let achievements = viewModel.getAchievements(
            unlockedIds: userDefaults.unlockedAchievements,
            totalPoints: userDefaults.totalPoints,
            eventCount: userDefaults.events.count
        )
        return achievements.filter { !$0.isUnlocked && $0.progress > 0 }.first
    }
    
    var topCategory: EventCategory? {
        let categoryCounts = Dictionary(grouping: userDefaults.events, by: { $0.category })
            .mapValues { $0.count }
        return categoryCounts.max(by: { $0.value < $1.value })?.key
    }
    
    var body: some View {
        ZStack {
        
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(greetingText())
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(userDefaults.userName)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .neonGlow(color: .neonBlue, radius: 4)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.neonYellow)
                                    .neonGlow(color: .neonYellow, radius: 4)
                                Text("\(currentStreak) day streak")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.neonYellow)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            showingSettings = true
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.darkCard)
                                    .frame(width: 50, height: 50)
                                
                                if let photoData = userDefaults.userPhotoData,
                                   let uiImage = UIImage(data: photoData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.neonPurple)
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.neonPurple, Color.neonPink],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .neonGlow(color: .neonPurple, radius: 4)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    VStack(spacing: 16) {
                        Button {
                            showDailyTask = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.darkCard, Color.darkAccent],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [Color.neonGreen.opacity(0.6), Color.neonBlue.opacity(0.6)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                                    .neonGlow(color: .neonGreen, radius: 4)
                                
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.neonGreen.opacity(0.3))
                                            .frame(width: 60, height: 60)
                                        
                                        Image(systemName: "target")
                                            .font(.system(size: 28))
                                            .foregroundColor(.neonGreen)
                                            .neonGlow(color: .neonGreen, radius: 6)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Daily Goal")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                        
                                        Text("\(todayPoints) / \(dailyGoal) points")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white.opacity(0.7))
                                        
                                        GeometryReader { geometry in
                                            ZStack(alignment: .leading) {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.darkCard)
                                                    .frame(height: 8)
                                                
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [Color.neonGreen, Color.neonBlue],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                                    .frame(width: geometry.size.width * dailyProgress, height: 8)
                                                    .neonGlow(color: .neonGreen, radius: 4)
                                            }
                                        }
                                        .frame(height: 8)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(Int(dailyProgress * 100))%")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.neonGreen)
                                }
                                .padding(20)
                            }
                        }
                        .frame(height: 110)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.darkCard, Color.darkAccent],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.neonYellow.opacity(0.6), Color.neonYellow.opacity(0.2)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 2
                                        )
                                )
                                .neonGlow(color: .neonYellow, radius: 6)
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.neonYellow)
                                        .neonGlow(color: .neonYellow, radius: 6)
                                    
                                    Text("Total Points")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    PulsingDot(color: .neonGreen)
                                }
                                
                                HStack(alignment: .bottom) {
                                    Text("\(userDefaults.totalPoints)")
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("Level \(userDefaults.totalPoints / 1000 + 1)")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.neonBlue)
                                            .neonGlow(color: .neonBlue, radius: 3)
                                        
                                        GeometryReader { geometry in
                                            ZStack(alignment: .leading) {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.darkCard)
                                                    .frame(height: 8)
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [Color.neonBlue, Color.neonPurple],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                                    .frame(width: geometry.size.width * (Double(userDefaults.totalPoints % 1000) / 1000.0), height: 8)
                                                    .neonGlow(color: .neonBlue, radius: 4)
                                            }
                                        }
                                        .frame(width: 100, height: 8)
                                    }
                                }
                            }
                            .padding(24)
                        }
                        .frame(height: 160)
                        
                        HStack(spacing: 16) {
                            Button {
                                navigateToTimeline = true
                            } label: {
                                StatCardViewNeon(
                                    title: "Events",
                                    value: "\(userDefaults.events.count)",
                                    icon: "calendar",
                                    color: .neonBlue
                                )
                            }
                            
                            Button {
                                navigateToAchievements = true
                            } label: {
                                StatCardViewNeon(
                                    title: "Achievements",
                                    value: "\(userDefaults.unlockedAchievements.count)",
                                    icon: "trophy.fill",
                                    color: .neonYellow
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if let nextAch = nextAchievement {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Next Achievement")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            Button {
                                navigateToAchievements = true
                            } label: {
                                NextAchievementCard(achievement: nextAch)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    if let topCat = topCategory {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Top Category")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            TopCategoryCard(category: topCat, count: userDefaults.events.filter { $0.category == topCat }.count)
                                .padding(.horizontal)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Actions")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(EventCategory.allCases, id: \.self) { category in
                                QuickActionButtonNeon(category: category) {
                                    addQuickEvent(category: category)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    if !userDefaults.events.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Recent Activity")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button {
                                    navigateToTimeline = true
                                } label: {
                                    HStack(spacing: 4) {
                                        Text("View All")
                                            .font(.system(size: 14, weight: .semibold))
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 12))
                                    }
                                    .foregroundColor(.neonBlue)
                                }
                            }
                            .padding(.horizontal)
                            
                            ForEach(Array(userDefaults.events.prefix(3))) { event in
                                EventRowViewNeon(event: event)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
//                .padding(40)
            }
            .background(
                DarkNeonBackgroundView()
            )
            if showCelebration {
                CelebrationView()
                    .transition(.scale.combined(with: .opacity))
            }
            
            NavigationLink(destination: TimelineView().environmentObject(userDefaults), isActive: $navigateToTimeline) {
                EmptyView()
            }
            .hidden()
            
            NavigationLink(destination: AchievementsView().environmentObject(userDefaults), isActive: $navigateToAchievements) {
                EmptyView()
            }
            .hidden()
        }
        .sheet(isPresented: $showDailyTask) {
            DailyTasksView(completedTasks: $completedDailyTasks)
                .environmentObject(userDefaults)
        }
        .onAppear {
            calculateTodayPoints()
        }
    }
    
    func greetingText() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }
    
    func calculateTodayPoints() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        todayPoints = userDefaults.events
            .filter { calendar.startOfDay(for: $0.timestamp) == today }
            .reduce(0) { $0 + $1.value }
    }
    
    func addQuickEvent(category: EventCategory) {
        let titles = [
            EventCategory.energy: ["Optimized lighting", "Reduced consumption", "Solar power boost", "Energy saved", "Smart grid activated"],
            EventCategory.water: ["Water saved", "Leak detected", "Usage optimized", "Filter cleaned", "Flow regulated"],
            EventCategory.security: ["Security check", "Access granted", "System armed", "Intrusion prevented", "Camera updated"],
            EventCategory.climate: ["Temperature adjusted", "Air quality improved", "Humidity balanced", "Ventilation optimized", "Climate stabilized"],
            EventCategory.automation: ["Routine completed", "Scene activated", "Schedule updated", "Task automated", "System synced"]
        ]
        
        let title = titles[category]?.randomElement() ?? "Event"
        let value = Int.random(in: 10...100)
        
        let event = Event(title: title, category: category, value: value)
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            userDefaults.addEvent(event)
            todayPoints += value
        }
        
        if userDefaults.totalPoints % 500 < value {
            withAnimation {
                showCelebration = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showCelebration = false
                }
            }
        }
    }
}
