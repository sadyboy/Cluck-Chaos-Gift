import SwiftUI

struct DarkNeonBackgroundView: View {
    @State private var animate = false
    @State private var rotate = false
    
    var body: some View {
        
        ZStack {
            Color.darkBg
                .ignoresSafeArea()
            
            ForEach(0..<8) { i in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                neonColors[i % neonColors.count].opacity(0.15),
                                neonColors[i % neonColors.count].opacity(0.05),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 250
                        )
                    )
                    .frame(width: 400, height: 400)
                    .offset(
                        x: animate ? positions[i].x : positions[i].x + 50,
                        y: animate ? positions[i].y : positions[i].y - 50
                    )
                    .blur(radius: 50)
            }
            
            ZStack {
                ForEach(0..<3) { i in
                    RoundedRectangle(cornerRadius: 200)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.neonBlue.opacity(0.3),
                                    Color.neonPurple.opacity(0.3),
                                    Color.neonPink.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 300 + CGFloat(i * 100), height: 300 + CGFloat(i * 100))
                        .rotationEffect(.degrees(rotate ? 360 : 0))
                        .blur(radius: 20)
                        .opacity(0.2)
                }
            }
            
            GridPattern()
                .stroke(Color.neonBlue.opacity(0.1), lineWidth: 1)
                .blur(radius: 1)
        }
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 10.0)
                    .repeatForever(autoreverses: true)
            ) {
                animate = true
            }
            
            withAnimation(
                Animation.linear(duration: 20.0)
                    .repeatForever(autoreverses: false)
            ) {
                rotate = true
            }
        }
    }
    
    private let neonColors: [Color] = [
        .neonBlue,
        .neonPurple,
        .neonPink,
        .neonGreen,
        .neonYellow
    ]
    
    private let positions: [CGPoint] = [
        CGPoint(x: -100, y: -150),
        CGPoint(x: 150, y: -100),
        CGPoint(x: -150, y: 100),
        CGPoint(x: 100, y: 150),
        CGPoint(x: 0, y: -200),
        CGPoint(x: -200, y: 0),
        CGPoint(x: 200, y: 50),
        CGPoint(x: 50, y: 200)
    ]
}

struct GridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let spacing: CGFloat = 30
        
        for i in stride(from: 0, through: rect.width, by: spacing) {
            path.move(to: CGPoint(x: i, y: 0))
            path.addLine(to: CGPoint(x: i, y: rect.height))
        }
        
        for i in stride(from: 0, through: rect.height, by: spacing) {
            path.move(to: CGPoint(x: 0, y: i))
            path.addLine(to: CGPoint(x: rect.width, y: i))
        }
        
        return path
    }
}
