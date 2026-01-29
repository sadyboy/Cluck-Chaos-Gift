import SwiftUI

struct StatCardViewNeon: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @State private var animate = false
    
    var body: some View {
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
                                colors: [color.opacity(0.6), color.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .neonGlow(color: color, radius: 4)
            
            VStack(alignment: .leading, spacing: 8) {
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
                        .rotationEffect(.degrees(animate ? 360 : 0))
                }
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.5)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 140)
        .onAppear {
            withAnimation(
                Animation.linear(duration: 10.0)
                    .repeatForever(autoreverses: false)
            ) {
                animate = true
            }
        }
    }
}

struct QuickActionButtonNeon: View {
    let category: EventCategory
    let action: () -> Void
    @State private var isPressed = false
    @State private var particles: [ParticleEffect] = []
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            createParticles()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
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
                                    colors: [category.color.opacity(0.8), category.color.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .neonGlow(color: isPressed ? category.color : category.color.opacity(0.5), radius: isPressed ? 10 : 4)
                
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [category.color.opacity(0.4), category.color.opacity(0.1)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 40
                                )
                            )
                            .frame(width: 60, height: 60)
                            .scaleEffect(isPressed ? 1.2 : 1.0)
                        
                        Image(systemName: category.icon)
                            .font(.system(size: 32))
                            .foregroundColor(category.color)
                            .neonGlow(color: category.color, radius: 8)
                    }
                    
                    Text(category.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding()
                
                ForEach(particles) { particle in
                    Circle()
                        .fill(category.color)
                        .frame(width: 6, height: 6)
                        .offset(x: particle.x, y: particle.y)
                        .opacity(particle.opacity)
                        .neonGlow(color: category.color, radius: 4)
                }
            }
            .frame(height: 120)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .rotation3DEffect(
                .degrees(isPressed ? 5 : 0),
                axis: (x: 1, y: 1, z: 0)
            )
        }
    }
    
    func createParticles() {
        particles.removeAll()
        for _ in 0..<8 {
            particles.append(ParticleEffect(
                x: CGFloat.random(in: -50...50),
                y: CGFloat.random(in: -50...50),
                opacity: 1.0
            ))
        }
        
        withAnimation(.easeOut(duration: 0.6)) {
            particles = particles.map { particle in
                ParticleEffect(
                    id: particle.id,
                    x: particle.x * 2,
                    y: particle.y * 2,
                    opacity: 0
                )
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            particles.removeAll()
        }
    }
}

struct ParticleEffect: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var opacity: Double
    
    init(id: UUID = UUID(), x: CGFloat, y: CGFloat, opacity: Double) {
        self.x = x
        self.y = y
        self.opacity = opacity
    }
}

struct CelebrationView: View {
    @State private var animate = false
    @State private var rotateStars = false
    @State private var scale = 0.5
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {}
            
            VStack(spacing: 30) {
                ZStack {
                    ForEach(0..<12) { i in
                        Image(systemName: "star.fill")
                            .font(.system(size: CGFloat.random(in: 20...40)))
                            .foregroundColor([Color.neonYellow, Color.neonPink, Color.neonBlue, Color.neonPurple][i % 4])
                            .offset(
                                x: animate ? cos(Double(i) * .pi / 6) * 120 : 0,
                                y: animate ? sin(Double(i) * .pi / 6) * 120 : 0
                            )
                            .opacity(animate ? 0 : 1)
                            .scaleEffect(animate ? 1.5 : 0.5)
                            .rotationEffect(.degrees(rotateStars ? 360 : 0))
                            .neonGlow(color: [Color.neonYellow, Color.neonPink, Color.neonBlue, Color.neonPurple][i % 4], radius: 8)
                    }
                    
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.neonYellow.opacity(0.6), Color.neonYellow.opacity(0.2), Color.clear],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 100
                                )
                            )
                            .frame(width: 200, height: 200)
                            .blur(radius: 30)
                            .scaleEffect(animate ? 1.5 : 1.0)
                        
                        Circle()
                            .fill(Color.darkCard)
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.neonYellow, Color.neonPink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 4
                            )
                            .frame(width: 120, height: 120)
                            .neonGlow(color: .neonYellow, radius: 12)
                        
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.neonYellow)
                            .neonGlow(color: .neonYellow, radius: 16)
                            .scaleEffect(scale)
                            .rotationEffect(.degrees(animate ? 360 : 0))
                    }
                }
                
                VStack(spacing: 12) {
                    Text("Milestone Reached!")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .neonGlow(color: .neonPurple, radius: 6)
                    
                    Text("Keep up the great work!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(Color.neonYellow)
                            .frame(width: 8, height: 8)
                            .scaleEffect(animate ? 1.0 : 0.5)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(i) * 0.2),
                                value: animate
                            )
                            .neonGlow(color: .neonYellow, radius: 4)
                    }
                }
            }
            .padding(50)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            colors: [Color.darkCard, Color.darkAccent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.neonYellow, Color.neonPink, Color.neonBlue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    )
                    .neonGlow(color: .neonYellow, radius: 20)
            )
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                scale = 1.0
                animate = true
            }
            
            withAnimation(
                Animation.linear(duration: 3.0)
                    .repeatForever(autoreverses: false)
            ) {
                rotateStars = true
            }
        }
    }
}

struct EventRowViewNeon: View {
    let event: Event
    @State private var appeared = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [event.category.color.opacity(0.4), event.category.color.opacity(0.2)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Circle()
                    .fill(Color.darkCard)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .stroke(event.category.color, lineWidth: 2)
                    .frame(width: 50, height: 50)
                    .neonGlow(color: event.category.color, radius: 4)
                
                Image(systemName: event.category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(event.category.color)
                    .neonGlow(color: event.category.color, radius: 4)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(event.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    CategoryBadge(category: event.category)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 11))
                        Text(event.timestamp.timeAgo())
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.white.opacity(0.6))
                }
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                    Text("+\(event.value)")
                        .font(.system(size: 20, weight: .black))
                }
                .foregroundColor(.neonYellow)
                .neonGlow(color: .neonYellow, radius: 4)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color.darkCard, Color.darkAccent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [event.category.color.opacity(0.5), event.category.color.opacity(0.2)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .neonGlow(color: event.category.color.opacity(0.3), radius: 2)
        .scaleEffect(appeared ? 1 : 0.9)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.05)) {
                appeared = true
            }
        }
    }
}

struct NextAchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
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
                                colors: [Color.neonPurple.opacity(0.6), Color.neonPink.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2
                        )
                )
                .neonGlow(color: .neonPurple, radius: 4)
            
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.neonPurple.opacity(0.3))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: achievement.icon)
                        .font(.system(size: 26))
                        .foregroundColor(.neonPurple)
                        .neonGlow(color: .neonPurple, radius: 6)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(achievement.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(achievement.description)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.darkCard)
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.neonPurple, Color.neonPink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * achievement.progress, height: 8)
                                .neonGlow(color: .neonPurple, radius: 4)
                        }
                    }
                    .frame(height: 8)
                    
                    Text("\(Int(achievement.progress * 100))% Complete")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.neonPurple)
                }
                
                Spacer()
            }
            .padding(20)
        }
        .frame(height: 120)
    }
}

struct TopCategoryCard: View {
    let category: EventCategory
    let count: Int
    
    var body: some View {
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
                                colors: [category.color.opacity(0.8), category.color.opacity(0.4)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2
                        )
                )
                .neonGlow(color: category.color, radius: 6)
            
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [category.color.opacity(0.5), category.color.opacity(0.2)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 40
                            )
                        )
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 32))
                        .foregroundColor(category.color)
                        .neonGlow(color: category.color, radius: 8)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Most Active")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text(category.rawValue)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("\(count) events completed")
                        .font(.system(size: 14))
                        .foregroundColor(category.color)
                }
                
                Spacer()
            }
            .padding(20)
        }
        .frame(height: 110)
    }
}

struct DailyTasksView: View {
    @EnvironmentObject var userDefaults: UserDefaultsManager
    @Environment(\.dismiss) var dismiss
    @Binding var completedTasks: Set<String>
    
    let tasks = [
        DailyTask(id: "energy", title: "Save Energy", description: "Complete 3 energy events", icon: "bolt.fill", color: Color(hex: "FFD700"), goal: 3, category: .energy),
        DailyTask(id: "water", title: "Water Conservation", description: "Monitor water 2 times", icon: "drop.fill", color: Color(hex: "00CED1"), goal: 2, category: .water),
        DailyTask(id: "points", title: "Point Hunter", description: "Earn 200 points today", icon: "star.fill", color: Color(hex: "F59E0B"), goal: 200, category: nil)
    ]
    
    var body: some View {
        ZStack {
            DarkNeonBackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Daily Tasks")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .neonGlow(color: .neonBlue, radius: 4)
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.darkCard)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.neonPink)
                        }
                        .neonGlow(color: .neonPink, radius: 4)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(tasks) { task in
                            DailyTaskRow(task: task, isCompleted: completedTasks.contains(task.id))
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct DailyTask: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let color: Color
    let goal: Int
    let category: EventCategory?
}

struct DailyTaskRow: View {
    let task: DailyTask
    let isCompleted: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [task.color.opacity(0.6), task.color.opacity(0.2)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2
                        )
                )
                .neonGlow(color: task.color, radius: isCompleted ? 6 : 3)
            
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(task.color.opacity(0.3))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : task.icon)
                        .font(.system(size: 28))
                        .foregroundColor(task.color)
                        .neonGlow(color: task.color, radius: 6)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(task.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(task.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                if isCompleted {
                    Text("✓")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.neonGreen)
                        .neonGlow(color: .neonGreen, radius: 8)
                }
            }
            .padding(20)
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        StatCardViewNeon(title: title, value: value, icon: icon, color: color)
    }
}
