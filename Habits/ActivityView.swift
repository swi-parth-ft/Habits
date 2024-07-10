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
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(.white.opacity(0.6))
                .opacity(0.4)
                .shadow(radius: 15)
                .frame(width: 350, height: 450)
            
            VStack(alignment: .leading) {
               
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
              
            }
            .padding(45)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }.preferredColorScheme(.dark)
        
    }
}


#Preview {
    // Provide sample data for the preview
            let sampleActivity = Activity(title: "Sample Activity", description: "This is a sample activity.", count: 0)
            let sampleHub = ActivityHub()
            sampleHub.activities.append(sampleActivity)
            
            return ActivityView(activity: sampleActivity, hub: sampleHub)
}
