//
//  ActivityView.swift
//  Habits
//
//  Created by Parth Antala on 2024-07-10.
//

import SwiftUI

struct ActivityView: View {
    
    @State var activity: Activity
    var hub: ActivityHub
    let color = Color(hex: 0x9dd44f)
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .fill(.black.opacity(0.9))
                    .opacity(0.4)
                    .shadow(radius: 15)
                    .frame(width: 350, height: 450)
                
                VStack(alignment: .center) {
                    
                    Text(activity.title)
                        .font(.system(size: 45))
                    Text(activity.description)
                        .font(.title)
                    Text("Current Streak")
                    Text("\(activity.count)")
                        .font(.system(size: 120))
                        .shadow(radius: 5)
                    
                    Button("Mark Today") {
                        if let index = hub.activities.firstIndex(of: activity) {
                            withAnimation {
                                var act = activity
                                act.count += 1
                                hub.activities[index] = act
                                activity = act
                            }
                        } else {
                            print("Activity not found")
                            print("\(String(describing: hub.activities.firstIndex(of: activity)))")
                        }
                    }
                    .buttonStyle()
                    .shadow(radius: 15)
                    
                    Button("Reset", systemImage: "arrow.counterclockwise") {
                        if let index = hub.activities.firstIndex(of: activity) {
                            withAnimation {
                                var act = activity
                                act.count = 0
                                hub.activities[index] = act
                                activity = act
                            }
                        } else {
                            print("Activity not found")
                            print("\(String(describing: hub.activities.firstIndex(of: activity)))")
                        }
                    }
                    
                }
                .foregroundColor(.white)
                .padding(45)
                .frame(maxWidth: .infinity, alignment: .center)
                
            }
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .background(TimelineView(.animation) { timeline in
            let x = (sin(timeline.date.timeIntervalSince1970) + 1) / 2
            
            MeshGradient(width: 3, height: 3, points: [
                [0, 0], [0.5, 0], [1, 0],
                [0, 0.5], [Float(x), 0.5], [1, 0.5],
                [0, 1], [0.5, 1], [1, 1]
            ], colors: [
                .black, .green, .green,
                .black, .green, .black,
                .black, .green, .green
            ])
        }
            .ignoresSafeArea()
                    
        )
        
    }
}


#Preview {
    // Provide sample data for the preview
    let sampleActivity = Activity(title: "Sample Activity", description: "This is a sample activity.", count: 0)
    let sampleHub = ActivityHub()
    sampleHub.activities.append(sampleActivity)
    
    return ActivityView(activity: sampleActivity, hub: sampleHub)
}
