//
//  NotificationsView.swift
//  Timetinerary
//
//  Created by Ben K on 10/11/21.
//

import SwiftUI

struct NotificationsView: View {
    @AppStorage("notifications", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var notifications: Bool = false
    
    @AppStorage("starts", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var starts: Bool = false
    @AppStorage("ends", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var ends: Bool = false
    
    @AppStorage("startOffset", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var startOffset: Int = 1
    @AppStorage("endOffset", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var endOffset: Int = 10
    
    @EnvironmentObject var timelineWeek: TimelineWeek
    
    var body: some View {
        Form {
            Toggle(isOn: $notifications.animation()) {
                Text("Notifications")
            }
            .onChange(of: notifications) { _ in
                Notifications.getPermissions()
            }
            
            if notifications {
                ClassGroup(title: "Starts", description: "Biology - Starting", enabled: $starts, offset: $startOffset)
                
                ClassGroup(title: "Ends", description: "History - Ending", enabled: $ends, offset: $endOffset)
            }
        }
        .navigationTitle("Notifications")
    }
    
    struct ClassGroup: View {
        let title: String
        let description: String
        
        @Binding var enabled: Bool
        @Binding var offset: Int
        
        var body: some View {
            Section {
                Toggle(isOn: $enabled.animation()) {
                    Text("Enable")
                }
                
                if enabled {
                    Stepper(value: $offset, in: 0...10) {
                        Text("Send **\(offset)** \(offset == 1 ? "minute" : "minutes") early")
                    }
                }
            } header: {
                Text("Class \(title)")
            } footer: {
                Text("Ex. '\(description) \(offset == 0 ? "now" : "in \(offset) \(offset == 1 ? "minute" : "minutes")")'")
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
