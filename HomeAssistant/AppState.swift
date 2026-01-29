import SwiftUI

class AppState: ObservableObject {
    @Published var showSplash = true
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 0.8)) {
                self.showSplash = false
            }
        }
    }
}
