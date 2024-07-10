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
        VStack {
            Text(activity.title)
            Text(activity.description)
            Text("\(activity.count)")
            
            Button("Plus") {
                
                if let index = hub.activities.firstIndex(of: activity) {
                    var act = activity
                    act.count += 1
                    hub.activities[index] = act
                    activity = act
                } else {
                    print("Activity not found")
                    print("\(String(describing: hub.activities.firstIndex(of: activity)))")
                }
            }
        }
    }
}

//#Preview {
//    ActivityView(activity: Activity())
//}
