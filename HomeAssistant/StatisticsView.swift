import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject var userDefaults: UserDefaultsManager
    
    var statisticsData: [StatisticsData] {
        EventCategory.allCases.map { category in
            let categoryEvents = userDefaults.events.filter { $0.category == category }
            let totalValue = categoryEvents.reduce(0) { $0 + $1.value }
            return StatisticsData(category: category, value: Double(totalValue), trend: Double.random(in: -10...20))
        }
    }
    
    var body: some View {
        ZStack {            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Statistics")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, Color(hex: "C7D2FE")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Category Breakdown")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                if #available(iOS 16.0, *) {
                                    Chart {
                                        ForEach(statisticsData) { data in
                                            BarMark(
                                                x: .value("Category", data.category.rawValue),
                                                y: .value("Value", data.value)
                                            )
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [data.category.color, data.category.color.opacity(0.6)],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .cornerRadius(8)
                                        }
                                    }
                                    .frame(height: 200)
                                    .chartXAxis {
                                        AxisMarks(values: .automatic) { _ in
                                            AxisValueLabel()
                                                .foregroundStyle(.white.opacity(0.7))
                                        }
                                    }
                                    .chartYAxis {
                                        AxisMarks { _ in
                                            AxisValueLabel()
                                                .foregroundStyle(.white.opacity(0.7))
                                        }
                                    }
                                } else {
                                    HStack(alignment: .bottom, spacing: 12) {
                                        ForEach(statisticsData) { data in
                                            VStack(spacing: 8) {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [data.category.color, data.category.color.opacity(0.6)],
                                                            startPoint: .top,
                                                            endPoint: .bottom
                                                        )
                                                    )
                                                    .frame(width: 40, height: max(data.value / 10, 20))
                                                
                                                Text(data.category.rawValue.prefix(3))
                                                    .font(.system(size: 10))
                                                    .foregroundColor(.white.opacity(0.7))
                                            }
                                        }
                                    }
                                    .frame(height: 200)
                                }
                            }
                            .padding(24)
                        }
                        
                        ForEach(statisticsData) { data in
                            StatCategoryCard(data: data)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Text("Progress Overview")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ProgressOverviewCard(
                            title: "Total Activity",
                            current: userDefaults.events.count,
                            goal: 100,
                            color: Color(hex: "6366F1")
                        )
                        
                        ProgressOverviewCard(
                            title: "Points Goal",
                            current: userDefaults.totalPoints,
                            goal: 10000,
                            color: Color(hex: "F59E0B")
                        )
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .background(
            DarkNeonBackgroundView()
        )
    }
}

struct StatCategoryCard: View {
    let data: StatisticsData
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [data.category.color.opacity(0.2), data.category.color.opacity(0.1)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(data.category.color.opacity(0.4), lineWidth: 1)
                )
            
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(data.category.color.opacity(0.3))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: data.category.icon)
                        .font(.system(size: 26))
                        .foregroundColor(data.category.color)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(data.category.rawValue)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("\(Int(data.value)) points")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(data.category.color)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: data.trend >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 12))
                        Text(String(format: "%.1f%%", abs(data.trend)))
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(data.trend >= 0 ? Color(hex: "10B981") : Color(hex: "EF4444"))
                    
                    Text("vs last week")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding(20)
        }
    }
}

struct ProgressOverviewCard: View {
    let title: String
    let current: Int
    let goal: Int
    let color: Color
    
    var progress: Double {
        min(Double(current) / Double(goal), 1.0)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
            
            VStack(spacing: 16) {
                HStack {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(current) / \(goal)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(color)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 20)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [color, color.opacity(0.6)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress, height: 20)
                    }
                }
                .frame(height: 20)
                
                HStack {
                    Text("\(Int(progress * 100))% Complete")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                }
            }
            .padding(20)
        }
    }
}
