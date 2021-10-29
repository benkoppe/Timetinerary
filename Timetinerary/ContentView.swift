//
//  ContentView.swift
//  Timetinerary
//
//  Created by Ben K on 10/5/21.
//

import SwiftUI
import WidgetKit
import WatchConnectivity

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @AppStorage("defaultSaved", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var savedKeys: [String] = []
    
    @StateObject var userColors: UserColors = UserColors()
    @StateObject var timelineWeek: TimelineWeek = TimelineWeek()
    
    var watchConnectivity = WatchConnectivity()
    
    @State private var changesMade = false
    
    @State private var importAlert = false
    @State private var importCount = 0
    
    var body: some View {
        TimeTableWeek()
            .environmentObject(userColors)
            .environmentObject(timelineWeek)
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("hasChanged"))) { _ in
                changesMade = true
                
                watchConnectivity.sendChanges(week: timelineWeek, colors: userColors)
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
            .onOpenURL { url in
                if url.isFileURL {
                    let templates = (try? Template.importURL(from: url)) ?? []
                    
                    importCount = 0
                    
                    for template in templates {
                        let data = template.data
                        let key = template.key
                        let newTimeline = Timeline(key: key)
                        newTimeline.timelineItems = TimelineItem.getTimelineItems(from: data) ?? []
                        if newTimeline.timelineItems.count > 0 {
                            savedKeys.append(key)
                            newTimeline.save()
                            importCount += 1
                        } else {
                            let defaults = UserDefaults.init(suiteName: "group.com.benk.timetinerary")
                            defaults?.removeObject(forKey: key)
                        }
                    }
                    
                    importAlert = true
                }
            }
            .alert("Tables Successfully Imported", isPresented: $importAlert) {} message: {
                Text("Imported \(importCount) tables.")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
