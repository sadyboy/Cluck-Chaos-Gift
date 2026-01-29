import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var userDefaults: UserDefaultsManager
    @State private var showingSettings = false
    @State private var showingShareSheet = false
    @State private var pulseAnimation = false
    @State private var isGeneratingImage = false
    @State private var shareImage: UIImage?
    
    var completionPercentage: Double {
        Double(userDefaults.unlockedAchievements.count) / 14.0
    }
    
    var totalEvents: Int {
        userDefaults.events.count
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile header section остается без изменений...
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [Color.neonPurple.opacity(0.6), Color.neonPurple.opacity(0.3), Color.clear],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 100
                                    )
                                )
                                .frame(width: 200, height: 200)
                                .blur(radius: 30)
                                .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                            
                            ZStack {
                                Circle()
                                    .fill(Color.darkCard)
                                    .frame(width: 140, height: 140)
                                
                                if let photoData = userDefaults.userPhotoData,
                                   let uiImage = UIImage(data: photoData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 140, height: 140)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.neonPurple)
                                        .neonGlow(color: .neonPurple, radius: 8)
                                }
                                
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.neonPurple, Color.neonPink, Color.neonBlue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 4
                                    )
                                    .frame(width: 140, height: 140)
                                    .neonGlow(color: .neonPurple, radius: 10)
                            }
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button {
                                        showingSettings = true
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(Color.neonBlue)
                                                .frame(width: 44, height: 44)
                                                .neonGlow(color: .neonBlue, radius: 8)
                                            
                                            Image(systemName: "pencil")
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .offset(x: -10, y: -10)
                                }
                            }
                            .frame(width: 140, height: 140)
                        }
                        
                        VStack(spacing: 8) {
                            Text(userDefaults.userName)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .neonGlow(color: .neonBlue, radius: 4)
                            
                            HStack(spacing: 8) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.neonYellow)
                                    .neonGlow(color: .neonYellow, radius: 4)
                                Text("Level \(userDefaults.totalPoints / 1000 + 1)")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.neonYellow)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.darkCard)
                                    .overlay(
                                        Capsule()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [Color.neonYellow, Color.neonYellow.opacity(0.5)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                            )
                            .neonGlow(color: .neonYellow, radius: 4)
                        }
                    }
                    .padding(.top, 40)
                    
                    // Statistics cards остаются без изменений...
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            ProfileStatCardNeon(
                                icon: "star.fill",
                                title: "Points",
                                value: "\(userDefaults.totalPoints)",
                                color: .neonYellow
                            )
                            
                            ProfileStatCardNeon(
                                icon: "calendar",
                                title: "Events",
                                value: "\(totalEvents)",
                                color: .neonBlue
                            )
                        }
                        
                        HStack(spacing: 16) {
                            ProfileStatCardNeon(
                                icon: "trophy.fill",
                                title: "Achievements",
                                value: "\(userDefaults.unlockedAchievements.count)/14",
                                color: .neonPink
                            )
                            
                            ProfileStatCardNeon(
                                icon: "flame.fill",
                                title: "Streak",
                                value: "7 days",
                                color: Color(hex: "FF6B35")
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Completion rate остаётся без изменений...
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "chart.pie.fill")
                                .foregroundColor(.neonPurple)
                            Text("Completion Rate")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(Int(completionPercentage * 100))%")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.neonPurple)
                        }
                        .padding(.horizontal)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.darkCard)
                                .frame(height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.neonPurple.opacity(0.6), Color.neonPurple.opacity(0.2)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                            lineWidth: 2
                                        )
                                )
                                .neonGlow(color: .neonPurple, radius: 4)
                            
                            HStack(spacing: 20) {
                                ZStack {
                                    Circle()
                                        .stroke(Color.darkAccent, lineWidth: 10)
                                        .frame(width: 70, height: 70)
                                    
                                    Circle()
                                        .trim(from: 0, to: completionPercentage)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.neonPurple, Color.neonPink],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                                        )
                                        .frame(width: 70, height: 70)
                                        .rotationEffect(.degrees(-90))
                                        .neonGlow(color: .neonPurple, radius: 6)
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Achievements Unlocked")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    Text("\(userDefaults.unlockedAchievements.count) of 14")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                            }
                            .padding(20)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Activity by category остаётся без изменений...
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.neonGreen)
                            Text("Activity by Category")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        
                        ForEach(EventCategory.allCases, id: \.self) { category in
                            CategoryProgressRowNeon(
                                category: category,
                                count: userDefaults.events.filter { $0.category == category }.count,
                                total: userDefaults.events.count
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // КНОПКИ ШАРИНГА
                    VStack(spacing: 16) {
                        Button {
                            prepareShareImage()
                        } label: {
                            HStack(spacing: 12) {
                                if isGeneratingImage {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 18))
                                }
                                Text("Share Progress")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.darkCard)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [Color.neonBlue.opacity(0.6), Color.neonPurple.opacity(0.6)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                            )
                            .neonGlow(color: .neonBlue, radius: 4)
                        }
                        .disabled(isGeneratingImage)
                        
                        Button {
                            shareTextProgress()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "text.bubble")
                                    .font(.system(size: 18))
                                Text("Share Stats")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.darkCard)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [Color.neonGreen.opacity(0.6), Color.neonCyan.opacity(0.6)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                            )
                            .neonGlow(color: .neonGreen, radius: 4)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .background(
            DarkNeonBackgroundView()
        )
        .fullScreenCover(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(userDefaults)
        }
        .sheet(isPresented: $showingShareSheet) {
            if let image = shareImage {
                ShareSheet(items: [image])
            }
        }
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
            ) {
                pulseAnimation = true
            }
        }
    }
    
    // MARK: - Share Functions
    
    private func prepareShareImage() {
        isGeneratingImage = true
        
        // Создаём красивую картинку для шаринга
        let shareView = ShareProgressView(
            userName: userDefaults.userName,
            totalPoints: userDefaults.totalPoints,
            achievementsCount: userDefaults.unlockedAchievements.count,
            totalEvents: totalEvents,
            completionPercentage: completionPercentage,
            level: userDefaults.totalPoints / 1000 + 1
        )
        .environmentObject(userDefaults)
        .frame(width: 1200, height: 1200)
        .background(Color.black)
        
        // Конвертируем View в UIImage
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let renderer = ImageRenderer(content: shareView)
            renderer.scale = 3.0
            
            if let uiImage = renderer.uiImage {
                self.shareImage = uiImage
                self.isGeneratingImage = false
                self.showingShareSheet = true
            } else {
                self.isGeneratingImage = false
                self.shareTextProgress()
            }
        }
    }
    
    private func shareTextProgress() {
        let shareText = """
        🌱 **My GardenMaster Progress** 🌱
        
        👤 \(userDefaults.userName)
        ⭐ Level \(userDefaults.totalPoints / 1000 + 1)
        🏆 Points: \(userDefaults.totalPoints)
        🎯 Achievements: \(userDefaults.unlockedAchievements.count)/14
        📊 Completion: \(Int(completionPercentage * 100))%
        📅 Events Completed: \(totalEvents)
        🔥 Current Streak: 7 days
        
        Download GardenMaster and start your gardening journey!
        """
        
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - Share Progress View
struct ShareProgressView: View {
    let userName: String
    let totalPoints: Int
    let achievementsCount: Int
    let totalEvents: Int
    let completionPercentage: Double
    let level: Int
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.05, blue: 0.15),
                    Color(red: 0.08, green: 0.08, blue: 0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("🌱 GardenMaster Progress")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("@\(userName)")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.neonPurple)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 30) {
                    ShareStatCard(
                        icon: "⭐",
                        title: "Level",
                        value: "\(level)",
                        gradient: [.yellow, .orange]
                    )
                    
                    ShareStatCard(
                        icon: "🏆",
                        title: "Points",
                        value: "\(totalPoints)",
                        gradient: [.purple, .pink]
                    )
                    
                    ShareStatCard(
                        icon: "🎯",
                        title: "Achievements",
                        value: "\(achievementsCount)/14",
                        gradient: [.blue, .cyan]
                    )
                    
                    ShareStatCard(
                        icon: "📊",
                        title: "Completion",
                        value: "\(Int(completionPercentage * 100))%",
                        gradient: [.green, .mint]
                    )
                }
                .padding(.horizontal, 40)
      
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Overall Progress")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(Int(completionPercentage * 100))%")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.neonGreen)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 20)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(
                                        colors: [.neonPurple, .neonPink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * completionPercentage, height: 20)
                                .shadow(color: .neonPurple, radius: 10, x: 0, y: 0)
                        }
                    }
                    .frame(height: 20)
                }
                .padding(.horizontal, 40)
        
                VStack(spacing: 12) {
                    Text("Join me on GardenMaster!")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("🌿 Master gardening skills • 📚 Interactive lessons • 🎮 Gamified learning")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
            }
            .padding(60)
        }
    }
}

struct ShareStatCard: View {
    let icon: String
    let title: String
    let value: String
    let gradient: [Color]
    
    var body: some View {
        VStack(spacing: 20) {
            Text(icon)
                .font(.system(size: 48))
            
            Text(value)
                .font(.system(size: 42, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .opacity(0.3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    LinearGradient(
                        colors: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
        )
    }
}

// MARK: - Share Sheet Wrapper
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ProfileStatCardNeon: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    @State private var animate = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [color.opacity(0.6), color.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .neonGlow(color: color, radius: 4)
            
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [color.opacity(0.4), color.opacity(0.2)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 30
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                        .neonGlow(color: color, radius: 6)
                        .scaleEffect(animate ? 1.1 : 1.0)
                }
                
                Text(value)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.5)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                animate = true
            }
        }
    }
}

struct CategoryProgressRowNeon: View {
    let category: EventCategory
    let count: Int
    let total: Int
    
    var progress: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [category.color.opacity(0.5), category.color.opacity(0.2)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                )
            
            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(category.color.opacity(0.3))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: category.icon)
                            .font(.system(size: 18))
                            .foregroundColor(category.color)
                    }
                    
                    Text(category.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(count)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(category.color)
                        .neonGlow(color: category.color, radius: 4)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.darkAccent)
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [category.color, category.color.opacity(0.6)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress, height: 6)
                            .neonGlow(color: category.color, radius: 4)
                    }
                }
                .frame(height: 6)
            }
            .padding(16)
        }
    }
}
