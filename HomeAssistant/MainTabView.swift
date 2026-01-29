import SwiftUI

struct MainTabView: View {
    @StateObject private var userDefaults = UserDefaultsManager()
    @State private var selectedTab = 0
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
//                DarkNeonBackgroundView()
//                
                TabView(selection: $selectedTab) {
                    HomeView(showingSettings: $showingSettings)
                        .environmentObject(userDefaults)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(0)
                    
                    TimelineView()
                        .environmentObject(userDefaults)
                        .tabItem {
                            Label("Timeline", systemImage: "clock.fill")
                        }
                        .tag(1)
                    
                    StatisticsView()
                        .environmentObject(userDefaults)
                        .tabItem {
                            Label("Statistics", systemImage: "chart.bar.fill")
                        }
                        .tag(2)
                    
                    AchievementsView()
                        .environmentObject(userDefaults)
                        .tabItem {
                            Label("Achievements", systemImage: "trophy.fill")
                        }
                        .tag(3)
                    
                    ProfileView()
                        .environmentObject(userDefaults)
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                        .tag(4)
                }
                .tint(Color.neonPurple)
            }
            .fullScreenCover(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(userDefaults)
            }
            .navigationBarHidden(true)
        }
    }
}
