import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static let neonBlue = Color(hex: "00F0FF")
    static let neonPurple = Color(hex: "B537FF")
    static let neonPink = Color(hex: "FF006E")
    static let neonGreen = Color(hex: "39FF14")
    static let neonYellow = Color(hex: "FFFF00")
    static let darkBg = Color(hex: "0A0A0F")
    static let darkCard = Color(hex: "1A1A2E")
    static let darkAccent = Color(hex: "16213E")
    

      static let neonCyan = Color(hex: "00FFFF")
  
}

extension View {
    func neonGlow(color: Color, radius: CGFloat = 8) -> some View {
        self
            .shadow(color: color.opacity(0.6), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.4), radius: radius * 1.5, x: 0, y: 0)
            .shadow(color: color.opacity(0.2), radius: radius * 2, x: 0, y: 0)
    }
    
    func glowingBorder(color: Color, lineWidth: CGFloat = 2) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color, lineWidth: lineWidth)
                .blur(radius: 4)
                .opacity(0.8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color, lineWidth: lineWidth)
        )
    }
}

extension Date {
    func timeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.second, .minute, .hour, .day, .weekOfYear], from: self, to: now)
        
        if let week = components.weekOfYear, week > 0 {
            return week == 1 ? "1 week ago" : "\(week) weeks ago"
        }
        if let day = components.day, day > 0 {
            return day == 1 ? "1 day ago" : "\(day) days ago"
        }
        if let hour = components.hour, hour > 0 {
            return hour == 1 ? "1 hour ago" : "\(hour) hours ago"
        }
        if let minute = components.minute, minute > 0 {
            return minute == 1 ? "1 min ago" : "\(minute) mins ago"
        }
        return "Just now"
    }
}
