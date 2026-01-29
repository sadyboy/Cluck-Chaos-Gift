import SwiftUI
import SpriteKit

struct SplashView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var rotateRings = false
    @State private var glowIntensity: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Color.darkBg
                .ignoresSafeArea()
            
            NeonSpaceSceneView()
                .ignoresSafeArea()
            
            ZStack {
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.neonBlue.opacity(0.6),
                                    Color.neonPurple.opacity(0.6),
                                    Color.neonPink.opacity(0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 200 + CGFloat(i * 60), height: 200 + CGFloat(i * 60))
                        .rotationEffect(.degrees(rotateRings ? 360 : 0))
                        .blur(radius: 10)
                        .opacity(0.4)
                }
            }
            
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.neonPurple.opacity(0.8),
                                    Color.neonBlue.opacity(0.6),
                                    Color.neonPink.opacity(0.4),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .blur(radius: 30)
                        .scaleEffect(glowIntensity)
                    
                    ZStack {
                        Circle()
                            .fill(Color.darkCard)
                            .frame(width: 130, height: 130)
                        
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.neonBlue, Color.neonPurple, Color.neonPink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 4
                            )
                            .frame(width: 130, height: 130)
                            .neonGlow(color: .neonPurple, radius: 16)
                        
                        Image(systemName: "house.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.neonBlue)
                            .neonGlow(color: .neonBlue, radius: 12)
                    }
                }
                .scaleEffect(scale)
                .opacity(opacity)
                .rotation3DEffect(
                    .degrees(opacity == 1.0 ? 0 : 20),
                    axis: (x: 1, y: 1, z: 0)
                )
                
                VStack(spacing: 12) {
                    Text("Cluck Chaos Gift\nSmart Home")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 42, weight: .black))
                        .foregroundColor(.white)
                        .neonGlow(color: .neonBlue, radius: 8)
                        .opacity(opacity)
                    
                    Text("Assistant")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.neonPurple)
                        .tracking(4)
                        .neonGlow(color: .neonPurple, radius: 6)
                        .opacity(opacity)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<3) { i in
                            Circle()
                                .fill(Color.neonBlue)
                                .frame(width: 8, height: 8)
                                .scaleEffect(opacity == 1.0 ? 1.0 : 0.5)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(i) * 0.2),
                                    value: opacity
                                )
                                .neonGlow(color: .neonBlue, radius: 4)
                        }
                    }
                    .padding(.top, 20)
                    .opacity(opacity)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                scale = 1.0
            }
            
            withAnimation(.easeIn(duration: 0.6).delay(0.1)) {
                opacity = 1.0
            }
            
            withAnimation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
            ) {
                glowIntensity = 1.5
            }
            
            withAnimation(
                Animation.linear(duration: 15.0)
                    .repeatForever(autoreverses: false)
            ) {
                rotateRings = true
            }
        }
    }
}

struct NeonSpaceSceneView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.backgroundColor = UIColor(red: 0.04, green: 0.04, blue: 0.06, alpha: 1.0)
        let scene = NeonSpaceScene()
        scene.scaleMode = .resizeFill
        view.presentScene(scene)
        view.allowsTransparency = true
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {}
}

class NeonSpaceScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        size = view.bounds.size
        
        for _ in 0..<200 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...2.5))
            let colors: [UIColor] = [
                UIColor(red: 0.0, green: 0.94, blue: 1.0, alpha: 1.0),
                UIColor(red: 0.71, green: 0.22, blue: 1.0, alpha: 1.0),
                UIColor(red: 1.0, green: 0.0, blue: 0.43, alpha: 1.0),
                .white
            ]
            star.fillColor = colors.randomElement()!
            star.strokeColor = .clear
            star.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            star.alpha = CGFloat.random(in: 0.4...1.0)
            
            star.glowWidth = CGFloat.random(in: 2...6)
            
            let twinkle = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.2, duration: Double.random(in: 0.5...2.0)),
                SKAction.fadeAlpha(to: 1.0, duration: Double.random(in: 0.5...2.0))
            ])
            star.run(SKAction.repeatForever(twinkle))
            
            addChild(star)
        }
        
        for _ in 0..<5 {
            let planet = SKShapeNode(circleOfRadius: CGFloat.random(in: 30...70))
            let colors: [UIColor] = [
                UIColor(red: 0.0, green: 0.94, blue: 1.0, alpha: 0.4),
                UIColor(red: 0.71, green: 0.22, blue: 1.0, alpha: 0.4),
                UIColor(red: 1.0, green: 0.0, blue: 0.43, alpha: 0.4)
            ]
            planet.fillColor = colors.randomElement()!
            planet.strokeColor = .white.withAlphaComponent(0.4)
            planet.lineWidth = 2
            planet.glowWidth = 8
            planet.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            
            let drift = SKAction.move(
                by: CGVector(dx: CGFloat.random(in: -60...60), dy: CGFloat.random(in: -60...60)),
                duration: Double.random(in: 4...8)
            )
            planet.run(SKAction.repeatForever(SKAction.sequence([drift, drift.reversed()])))
            
            addChild(planet)
        }
    }
}
