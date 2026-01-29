import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var userDefaults: UserDefaultsManager
    @State private var selectedCategory: EventCategory?
    @State private var selectedEvent: Event?
    @State private var showEventDetail = false
    @State private var showDeleteAlert = false
    @State private var eventToDelete: Event?
    @State private var searchText = ""
    @State private var sortOption: SortOption = .newest
    @State private var showFilters = false
    
    enum SortOption: String, CaseIterable {
        case newest = "Newest First"
        case oldest = "Oldest First"
        case highestPoints = "Highest Points"
        case category = "Category"
    }
    
    var filteredEvents: [Event] {
        var events = userDefaults.events
        
        if let category = selectedCategory {
            events = events.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            events = events.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch sortOption {
        case .newest:
            events.sort { $0.timestamp > $1.timestamp }
        case .oldest:
            events.sort { $0.timestamp < $1.timestamp }
        case .highestPoints:
            events.sort { $0.value > $1.value }
        case .category:
            events.sort { $0.category.rawValue < $1.category.rawValue }
        }
        
        return events
    }
    
    var eventsByDate: [String: [Event]] {
        Dictionary(grouping: filteredEvents) { event in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: event.timestamp)
        }
    }
    
    var sortedDates: [String] {
        eventsByDate.keys.sorted { date1, date2 in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            guard let d1 = formatter.date(from: date1),
                  let d2 = formatter.date(from: date2) else { return false }
            return d1 > d2
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Timeline")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .neonGlow(color: .neonBlue, radius: 6)
                            
                            Text("\(filteredEvents.count) events")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                showFilters.toggle()
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.darkCard)
                                    .frame(width: 44, height: 44)
                                    .neonGlow(color: showFilters ? .neonPurple : .neonBlue, radius: 4)
                                
                                Image(systemName: showFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(showFilters ? .neonPurple : .neonBlue)
                            }
                        }
                    }
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.neonBlue)
                                .font(.system(size: 16))
                            
                            TextField("Search events...", text: $searchText)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .autocorrectionDisabled()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.darkCard)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.neonBlue.opacity(0.5), Color.neonPurple.opacity(0.5)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                        )
                        
                        if !searchText.isEmpty {
                            Button {
                                withAnimation {
                                    searchText = ""
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.neonPink)
                                    .font(.system(size: 20))
                            }
                        }
                    }
                    
                    if showFilters {
                        VStack(spacing: 12) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    FilterChipNeon(title: "All", isSelected: selectedCategory == nil, color: .neonBlue) {
                                        withAnimation {
                                            selectedCategory = nil
                                        }
                                    }
                                    
                                    ForEach(EventCategory.allCases, id: \.self) { category in
                                        FilterChipNeon(
                                            title: category.rawValue,
                                            isSelected: selectedCategory == category,
                                            color: category.color
                                        ) {
                                            withAnimation {
                                                selectedCategory = category
                                            }
                                        }
                                    }
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(SortOption.allCases, id: \.self) { option in
                                        SortChip(option: option, isSelected: sortOption == option) {
                                            withAnimation {
                                                sortOption = option
                                            }
                                        }
                                    }
                                }
                            }
                        }
//                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .padding()
                
                if filteredEvents.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [Color.neonPurple.opacity(0.3), Color.clear],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 80
                                    )
                                )
                                .frame(width: 160, height: 160)
                                .blur(radius: 20)
                            
                            Image(systemName: searchText.isEmpty ? "clock.badge.exclamationmark" : "magnifyingglass")
                                .font(.system(size: 70))
                                .foregroundColor(.neonPurple)
                                .neonGlow(color: .neonPurple, radius: 12)
                        }
                        
                        VStack(spacing: 8) {
                            Text(searchText.isEmpty ? "No events yet" : "No results found")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(searchText.isEmpty ? "Start adding events from the home screen" : "Try adjusting your search or filters")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.6))
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(sortedDates, id: \.self) { date in
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text(date)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.neonBlue)
                                            .neonGlow(color: .neonBlue, radius: 4)
                                        
                                        Rectangle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.neonBlue.opacity(0.6), Color.clear],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(height: 1)
                                    }
                                    .padding(.horizontal)
                                    
                                    ForEach(eventsByDate[date] ?? []) { event in
                                        TimelineEventCardNeon(event: event)
                                            .onTapGesture {
                                                selectedEvent = event
                                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                                    showEventDetail = true
                                                }
                                            }
                                            .contextMenu {
                                                Button(role: .destructive) {
                                                    eventToDelete = event
                                                    showDeleteAlert = true
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
                                    }
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .background(
            DarkNeonBackgroundView()
        )
        .sheet(item: $selectedEvent, content: { model in
            EventDetailView(event: model)
                .environmentObject(userDefaults)
        })

        .alert("Delete Event", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                if let event = eventToDelete {
                    deleteEvent(event)
                }
            }
        } message: {
            Text("Are you sure you want to delete this event?")
        }
    }
    
    func deleteEvent(_ event: Event) {
        withAnimation {
            userDefaults.events.removeAll { $0.id == event.id }
            userDefaults.totalPoints = max(0, userDefaults.totalPoints - event.value)
        }
    }
}

struct FilterChipNeon: View {
    let title: String
    var isSelected: Bool
    var color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isSelected ? .black : .white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? color : Color.darkCard)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(color, lineWidth: isSelected ? 0 : 1)
                        )
                )
                .neonGlow(color: isSelected ? color : .clear, radius: isSelected ? 6 : 0)
        }
    }
}

struct SortChip: View {
    let option: TimelineView.SortOption
    var isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: iconForOption(option))
                    .font(.system(size: 12))
                Text(option.rawValue)
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(isSelected ? .black : .white.opacity(0.8))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.neonYellow : Color.darkCard)
                    .overlay(
                        Capsule()
                            .stroke(Color.neonYellow.opacity(0.5), lineWidth: isSelected ? 0 : 1)
                    )
            )
            .neonGlow(color: isSelected ? .neonYellow : .clear, radius: isSelected ? 4 : 0)
        }
    }
    
    func iconForOption(_ option: TimelineView.SortOption) -> String {
        switch option {
        case .newest: return "arrow.down"
        case .oldest: return "arrow.up"
        case .highestPoints: return "star.fill"
        case .category: return "square.grid.2x2"
        }
    }
}

struct TimelineEventCardNeon: View {
    let event: Event
    @State private var appeared = false
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [event.category.color, event.category.color.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 4)
                .neonGlow(color: event.category.color, radius: 6)
            
            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.darkCard)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [event.category.color, event.category.color.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .frame(width: 60, height: 60)
                            .neonGlow(color: event.category.color, radius: 4)
                        
                        Image(systemName: event.category.icon)
                            .font(.system(size: 24))
                            .foregroundColor(event.category.color)
                    }
                    
                    Text(event.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(event.category.rawValue)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(event.category.color)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(event.category.color.opacity(0.2))
                                    .overlay(
                                        Capsule()
                                            .stroke(event.category.color.opacity(0.5), lineWidth: 1)
                                    )
                            )
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 14))
                            Text("+\(event.value)")
                                .font(.system(size: 18, weight: .black))
                        }
                        .foregroundColor(.neonYellow)
                        .neonGlow(color: .neonYellow, radius: 4)
                    }
                    
                    Text(event.title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                        Text(event.timestamp.timeAgo())
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.white.opacity(0.5))
                }
                .padding(.vertical, 4)
                
                Spacer()
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
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [event.category.color.opacity(0.6), event.category.color.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .scaleEffect(appeared ? (isPressed ? 0.98 : 1) : 0.9)
        .opacity(appeared ? 1 : 0)
        .rotation3DEffect(
            .degrees(appeared ? 0 : 10),
            axis: (x: 1, y: 0, z: 0)
        )
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double.random(in: 0...0.1))) {
                appeared = true
            }
        }
    }
}

struct EventDetailView: View {
    @EnvironmentObject var userDefaults: UserDefaultsManager
    @Environment(\.dismiss) var dismiss
    let event: Event
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    
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
                    
                    Text("Event Details")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 44, height: 44)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 32) {
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [event.category.color.opacity(0.4), Color.clear],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 100
                                    )
                                )
                                .frame(width: 200, height: 200)
                                .blur(radius: 30)
                            
                            ZStack {
                                Circle()
                                    .fill(Color.darkCard)
                                    .frame(width: 140, height: 140)
                                
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [event.category.color, event.category.color.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 4
                                    )
                                    .frame(width: 140, height: 140)
                                    .neonGlow(color: event.category.color, radius: 10)
                                
                                Image(systemName: event.category.icon)
                                    .font(.system(size: 60))
                                    .foregroundColor(event.category.color)
                                    .neonGlow(color: event.category.color, radius: 8)
                            }
                        }
                        .scaleEffect(scale)
                        .opacity(opacity)
                        
                        VStack(spacing: 20) {
                            Text(event.title)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .neonGlow(color: event.category.color, radius: 4)
                            
                            Text(event.category.rawValue)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(event.category.color)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(event.category.color.opacity(0.2))
                                        .overlay(
                                            Capsule()
                                                .stroke(event.category.color, lineWidth: 2)
                                        )
                                )
                                .neonGlow(color: event.category.color, radius: 6)
                        }
                        
                        VStack(spacing: 16) {
                            DetailRow(icon: "star.fill", title: "Points Earned", value: "+\(event.value)", color: .neonYellow)
                            DetailRow(icon: "calendar", title: "Date", value: event.timestamp.formatted(date: .long, time: .omitted), color: .neonBlue)
                            DetailRow(icon: "clock.fill", title: "Time", value: event.timestamp.formatted(date: .omitted, time: .shortened), color: .neonPurple)
                            DetailRow(icon: "timer", title: "Time Ago", value: event.timestamp.timeAgo(), color: .neonPink)
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            Text("Impact")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 16) {
                                ImpactCard(icon: "bolt.fill", value: "\(event.value * 2)", label: "Energy", color: .neonYellow)
                                ImpactCard(icon: "leaf.fill", value: "\(event.value)", label: "Eco", color: .neonGreen)
                                ImpactCard(icon: "chart.line.uptrend.xyaxis", value: "+\(Int.random(in: 5...20))%", label: "Efficiency", color: .neonBlue)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 20)
                }
            }
        }
        .background(
            DarkNeonBackgroundView()
        )
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.darkCard)
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }
            .neonGlow(color: color, radius: 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkCard.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct ImpactCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
                .neonGlow(color: color, radius: 6)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
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
