//
//  Notifications.swift
//  Timetinerary
//
//  Created by Ben K on 10/11/21.
//

import Foundation
import UserNotifications

struct Notifications {
    static func getPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications Enabled")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func schedule(for week: TimelineWeek) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let defaults = UserDefaults.init(suiteName: "group.com.benk.timetinerary")
        
        let enabled = defaults?.bool(forKey: "notifications") ?? false
        
        if enabled {
            let starts = defaults?.bool(forKey: "starts") ?? false
            let ends = defaults?.bool(forKey: "ends") ?? false
            
            if starts { scheduleStarts(for: week) }
            if ends { scheduleEnds(for: week) }
        }
        
        print("Scheduled notifications!")
    }
    
    private static func scheduleStarts(for week: TimelineWeek) {
        for day in WeekDays.allCases {
            let timeline = week.getTimeline(day: day)
            scheduleStarts(for: timeline, onDay: day)
        }
    }
    
    private static func scheduleStarts(for timeline: Timeline, onDay: WeekDays) {
        let defaults = UserDefaults.init(suiteName: "group.com.benk.timetinerary")
        let offset = defaults?.integer(forKey: "startOffset") ?? 1
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
    
    private static func scheduleEnds(for week: TimelineWeek) {
        for day in WeekDays.allCases {
            let timeline = week.getTimeline(day: day)
            scheduleEnds(for: timeline, onDay: day)
        }
    }
    
    private static func scheduleEnds(for timeline: Timeline, onDay: WeekDays) {
        let defaults = UserDefaults.init(suiteName: "group.com.benk.timetinerary")
        let offset = defaults?.integer(forKey: "endOffset") ?? 10
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
