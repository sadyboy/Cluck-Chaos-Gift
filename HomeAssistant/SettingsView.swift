import SwiftUI
import PhotosUI

struct SettingsView: View {
    @EnvironmentObject var userDefaults: UserDefaultsManager
    @Environment(\.dismiss) var dismiss
    @State private var editedName: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingSaveAnimation = false
    @State private var selectedTheme: ColorTheme = .purple
    @State private var showResetAlert = false
    @State private var pulseAnimation = false
    
    enum ColorTheme: String, CaseIterable {
        case purple = "Purple"
        case blue = "Blue"
        case pink = "Pink"
        case green = "Green"
        case orange = "Orange"
        
        var primaryColor: Color {
            switch self {
            case .purple: return .neonPurple
            case .blue: return .neonBlue
            case .pink: return .neonPink
            case .green: return .neonGreen
            case .orange: return Color(hex: "FF6B35")
            }
        }
    }
    
    var body: some View {
        ZStack {
           
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.darkCard)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.neonPink)
                        }
                        .neonGlow(color: .neonPink, radius: 4)
                    }
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .neonGlow(color: .neonBlue, radius: 4)
                    
                    Spacer()
                    
                    Button {
                        saveSettings()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.darkCard)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.neonGreen)
                        }
                        .neonGlow(color: .neonGreen, radius: 6)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 32) {
                        VStack(spacing: 24) {
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                colors: [selectedTheme.primaryColor.opacity(0.6), selectedTheme.primaryColor.opacity(0.3)],
                                                center: .center,
                                                startRadius: 0,
                                                endRadius: 80
                                            )
                                        )
                                        .frame(width: 160, height: 160)
                                        .blur(radius: 20)
                                        .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                                    
                                    Circle()
                                        .fill(Color.darkCard)
                                        .frame(width: 130, height: 130)
                                    
                                    if let photoData = userDefaults.userPhotoData,
                                       let uiImage = UIImage(data: photoData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 130, height: 130)
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 60))
                                            .foregroundColor(selectedTheme.primaryColor)
                                            .neonGlow(color: selectedTheme.primaryColor, radius: 8)
                                    }
                                    
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [selectedTheme.primaryColor, selectedTheme.primaryColor.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 3
                                        )
                                        .frame(width: 130, height: 130)
                                        .neonGlow(color: selectedTheme.primaryColor, radius: 8)
                                    
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            ZStack {
                                                Circle()
                                                    .fill(selectedTheme.primaryColor)
                                                    .frame(width: 42, height: 42)
                                                    .neonGlow(color: selectedTheme.primaryColor, radius: 6)
                                                
                                                Image(systemName: "camera.fill")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(.white)
                                            }
                                            .offset(x: -5, y: -5)
                                        }
                                    }
                                    .frame(width: 130, height: 130)
                                }
                            }
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                            userDefaults.userPhotoData = data
                                        }
                                    }
                                }
                            }
                            
                            Text("Tap to change photo")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "person.text.rectangle")
                                    .foregroundColor(.neonBlue)
                                Text("Name")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            TextField("Enter your name", text: $editedName)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .padding(16)
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
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "paintpalette.fill")
                                    .foregroundColor(.neonPurple)
                                Text("Color Theme")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(ColorTheme.allCases, id: \.self) { theme in
                                        ThemeButton(
                                            theme: theme,
                                            isSelected: selectedTheme == theme
                                        ) {
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                                selectedTheme = theme
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(.neonYellow)
                                Text("Your Stats")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            HStack(spacing: 16) {
                                UserStatCard(
                                    icon: "star.fill",
                                    title: "Total Points",
                                    value: "\(userDefaults.totalPoints)",
                                    color: .neonYellow
                                )
                                
                                UserStatCard(
                                    icon: "calendar",
                                    title: "Events",
                                    value: "\(userDefaults.events.count)",
                                    color: .neonBlue
                                )
                            }
                            .padding(.horizontal)
                            
                            HStack(spacing: 16) {
                                UserStatCard(
                                    icon: "trophy.fill",
                                    title: "Achievements",
                                    value: "\(userDefaults.unlockedAchievements.count)/14",
                                    color: .neonPink
                                )
                                
                                UserStatCard(
                                    icon: "flame.fill",
                                    title: "Level",
                                    value: "\(userDefaults.totalPoints / 1000 + 1)",
                                    color: .neonGreen
                                )
                            }
                            .padding(.horizontal)
                        }
                        
                        VStack(spacing: 16) {
                            Button {
                                showResetAlert = true
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: 18))
                                    Text("Reset All Data")
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
                                                        colors: [Color.red.opacity(0.6), Color.orange.opacity(0.6)],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    ),
                                                    lineWidth: 2
                                                )
                                        )
                                )
                                .neonGlow(color: .red, radius: 4)
                            }
                            .padding(.horizontal)
                        }
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "app.badge")
                                    .foregroundColor(.white.opacity(0.5))
                                Text("App Version")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            
                            Text("1.0.0")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            
            if showingSaveAnimation {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [Color.neonGreen.opacity(0.6), Color.neonGreen.opacity(0.3)],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 60
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .blur(radius: 20)
                            
                            Circle()
                                .fill(Color.darkCard)
                                .frame(width: 90, height: 90)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 45, weight: .bold))
                                .foregroundColor(.neonGreen)
                                .neonGlow(color: .neonGreen, radius: 12)
                        }
                        
                        VStack(spacing: 8) {
                            Text("Settings Saved!")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .neonGlow(color: .neonGreen, radius: 4)
                            
                            Text("Your changes have been applied")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(40)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.darkCard)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.neonGreen, Color.neonBlue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 3
                                    )
                            )
                            .neonGlow(color: .neonGreen, radius: 12)
                    )
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .background(
            DarkNeonBackgroundView()
        )
        .alert("Reset All Data", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("This will delete all your events, achievements, and points. This action cannot be undone.")
        }
        .onAppear {
            editedName = userDefaults.userName
            
            withAnimation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
            ) {
                pulseAnimation = true
            }
        }
    }
    
    func saveSettings() {
        if !editedName.isEmpty {
            userDefaults.userName = editedName
        }
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showingSaveAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showingSaveAnimation = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                dismiss()
            }
        }
    }
    
    func resetAllData() {
        withAnimation {
            userDefaults.events = []
            userDefaults.totalPoints = 0
            userDefaults.unlockedAchievements = Set()
        }
    }
}

struct ThemeButton: View {
    let theme: SettingsView.ColorTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [theme.primaryColor.opacity(0.8), theme.primaryColor.opacity(0.4)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 40
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .neonGlow(color: theme.primaryColor, radius: 8)
                    }
                }
                .overlay(
                    Circle()
                        .stroke(
                            theme.primaryColor,
                            lineWidth: isSelected ? 3 : 2
                        )
                        .frame(width: 60, height: 60)
                )
                .neonGlow(color: isSelected ? theme.primaryColor : .clear, radius: isSelected ? 8 : 0)
                
                Text(theme.rawValue)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(isSelected ? theme.primaryColor : .white.opacity(0.7))
            }
        }
    }
}

struct UserStatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
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
            }
            
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
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
        )
        .neonGlow(color: color, radius: 3)
    }
}
