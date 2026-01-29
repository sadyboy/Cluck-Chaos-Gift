import SwiftUI

struct AnimatedBackgroundView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<5) { i in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(hex: gradientColors[i]).opacity(0.3),
                                Color(hex: gradientColors[i]).opacity(0.0)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 200
                        )
                    )
                    .frame(width: 300, height: 300)
                    .offset(
                        x: animate ? CGFloat.random(in: -100...100) : CGFloat.random(in: -150...150),
                        y: animate ? CGFloat.random(in: -100...100) : CGFloat.random(in: -150...150)
                    )
                    .blur(radius: 40)
            }
        }
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 8.0)
                    .repeatForever(autoreverses: true)
            ) {
                animate = true
            }
        }
    }
    
    private let gradientColors = [
        "6366F1",
        "8B5CF6",
        "D946EF",
        "00CED1",
        "F59E0B"
    ]
}
