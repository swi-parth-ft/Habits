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
                
            }
            .sheet(isPresented: $isAddFormVisible) {
                // show an AddView here
                AddView(activities: activities)
                    .presentationDetents([.fraction(0.4), .medium, .large])
            }
        }
    }
}

struct AddView: View {
    
    @State private var title = ""
    @State private var description = ""
    @Environment(\.dismiss) var dismiss
    
    
    var activities: ActivityHub
    
    var body: some View {
        VStack {
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

#Preview {
    ContentView()
}
