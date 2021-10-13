//
//  ContentView.swift
//  Timetinerary
//
//  Created by Ben K on 10/5/21.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var userColors: UserColors = UserColors()
    @StateObject var timelineWeek: TimelineWeek = TimelineWeek()
    
    @State private var changesMade = false
    
    var body: some View {
        TimeTableWeek()
            .environmentObject(userColors)
            .environmentObject(timelineWeek)
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("hasChanged"))) { _ in
                changesMade = true
            }
            .onAppear {
                WidgetCenter.shared.reloadAllTimelines()
            }
            .onChange(of: scenePhase) { phase in
                if phase == .background && changesMade {
                    WidgetCenter.shared.reloadAllTimelines()
                    changesMade = false
                }
                Notifications().schedule(for: timelineWeek)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
