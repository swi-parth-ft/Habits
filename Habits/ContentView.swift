//
//  ContentView.swift
//  Habits
//
//  Created by Parth Antala on 2024-07-10.
//

import SwiftUI
struct Activity: Identifiable, Codable, Hashable, Equatable {
    var id = UUID()
    var title: String
    var description: String
    var count: Int = 0
}

@Observable
class ActivityHub: ObservableObject {
    var activities = [Activity](){
        didSet {
            if let encoded = try? JSONEncoder().encode(activities) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    init() {
        if let savedActivities = UserDefaults.standard.data(forKey: "Activities") {
            if let decodedItems = try? JSONDecoder().decode([Activity].self, from: savedActivities) {
                activities = decodedItems
                return
            }
        }
        
        activities = []
    }
}


struct ContentView: View {
    
    @State private var isAddFormVisible: Bool = false
    @State private var activities = ActivityHub()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(activities.activities) { activity in
                        NavigationLink(value: activity) {
                            Text(activity.title)
                                .font(.headline)
                        }
                        
                    }
                    .onDelete(perform: removeItems)
                }
                    .navigationDestination(for: Activity.self) { activity in
                        ActivityView(activity: activity, hub: activities)
                    }
                
            }
            .navigationTitle("Activities")
            .toolbar {
                    Button("Add") {
                        isAddFormVisible = true
                    }
                    .buttonStyle()
                
            }
            .sheet(isPresented: $isAddFormVisible) {
                // show an AddView here
                AddView(activities: activities)
                    .presentationDetents([.fraction(0.4), .medium, .large])
            }
        }
        .preferredColorScheme(.dark)
    }
    
    func removeItems(at offsets: IndexSet) {
        activities.activities.remove(atOffsets: offsets)
    }
}

struct AddView: View {
    
    @State private var title = ""
    @State private var description = ""
    @Environment(\.dismiss) var dismiss
    
    
    var activities: ActivityHub
    
    var body: some View {
        VStack {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                Button("Save") {
                    let activity = Activity(title: title, description: description)
                    activities.activities.append(activity)
                    dismiss()
                }
            }
        }
    }
}

struct ButtonViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
        .buttonStyle(.borderedProminent)
        .tint(Color(hex: 0x9dd44f).opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

extension View {
    func buttonStyle() -> some View {
        modifier(ButtonViewModifier())
    }
}


extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

#Preview {
    ContentView()
}
