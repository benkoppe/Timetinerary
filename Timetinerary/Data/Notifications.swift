//
//  Notifications.swift
//  Timetinerary
//
//  Created by Ben K on 10/11/21.
//

import Foundation
import UserNotifications
import SwiftUI

struct Notifications {
    @AppStorage("notifications", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var enabled: Bool = false
    
    @AppStorage("starts", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var starts: Bool = false
    @AppStorage("ends", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var ends: Bool = false
    
    @AppStorage("startOffset", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var startOffset: Int = 1
    @AppStorage("endOffset", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var endOffset: Int = 10
    
    static func getPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications Enabled")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func schedule(for week: TimelineWeek) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        if enabled {
            if starts { scheduleStarts(for: week) }
            if ends { scheduleEnds(for: week) }
        }
        
        print("Scheduled notifications!")
    }
    
    private func scheduleStarts(for week: TimelineWeek) {
        for day in WeekDays.allCases {
            let timeline = week.getTimeline(day: day)
            scheduleStarts(for: timeline, onDay: day)
        }
    }
    
    private func scheduleStarts(for timeline: Timeline, onDay: WeekDays) {
        let offset = startOffset
        let zeroOffset = offset == 0
        
        for (index, item) in timeline.timelineItems.enumerated() {
            if index != timeline.timelineItems.count - 1 {
                let content = UNMutableNotificationContent()
                content.title = "\(item.name)"
                content.body = "Starting \(zeroOffset ? "now" : "in \(offset) \(offset == 1 ? "minute" : "minutes")")"
                
                var components = DateComponents()
                components.weekday = onDay.weekDay
                components.hour = item.hour
                components.minute = item.minute - offset
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    private func scheduleEnds(for week: TimelineWeek) {
        for day in WeekDays.allCases {
            let timeline = week.getTimeline(day: day)
            scheduleEnds(for: timeline, onDay: day)
        }
    }
    
    private func scheduleEnds(for timeline: Timeline, onDay: WeekDays) {
        let offset = endOffset
        let zeroOffset = offset == 0
        
        var lastItem: TimelineItem?
        
        for (index, item) in timeline.timelineItems.enumerated().reversed() {
            if index != timeline.timelineItems.count - 1, let lastItem = lastItem {
                let content = UNMutableNotificationContent()
                content.title = "\(item.name)"
                content.body = "Ending \(zeroOffset ? "now" : "in \(offset) \(offset == 1 ? "minute" : "minutes")")"
                
                var components = DateComponents()
                components.weekday = onDay.weekDay
                components.hour = lastItem.hour
                components.minute = lastItem.minute - offset
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }
            
            lastItem = item
        }
    }
}
