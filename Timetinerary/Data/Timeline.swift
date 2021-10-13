//
//  TimelineItem.swift
//  Upkeep
//
//  Created by Ben K on 10/5/21.
//

import Foundation
import SwiftUI
import WidgetKit

enum TimelineMoment {
    case empty
    case conflicts
    case before(firstItem: TimelineItem)
    case after(lastItem: TimelineItem)
    case during(item: TimelineItem, nextItem: TimelineItem)
}

class Timeline: ObservableObject, Identifiable {
    var key: String
    
    @Published var timelineItems: [TimelineItem] {
        didSet {
            save()
        }
    }
    
    init(key: String = "defaultTimeline") {
        let defaults = UserDefaults.init(suiteName: "group.com.benk.timetinerary")
        let timelineData: [Data] = defaults?.array(forKey: key) as? [Data] ?? []
        
        var arr: [TimelineItem] = []
        for data in timelineData {
            if let timelineItem = TimelineItem.getTimelineItem(from: data) {
                arr.append(timelineItem)
            }
        }
        
        if arr.isEmpty {
            arr.append(TimelineItem(name: "", hour: 7, minute: 25))
        }
        
        self.key = key
        self.timelineItems = arr
    }
    
    init(items: [TimelineItem]) {
        self.key = ""
        self.timelineItems = items
    }
    
    func getMoment(at time: Date) -> TimelineMoment {
        if getConflicts() > 0 { return .conflicts }
        if timelineItems.count < 2 { return .empty }
        
        let firstItem = timelineItems.first!
        let lastItem = timelineItems.last!
        
        if time < firstItem.getDate(for: time) { return .before(firstItem: firstItem) }
        if time > lastItem.getDate(for: time) { return .after(lastItem: lastItem) }
        
        var returnItem: TimelineItem = firstItem
        var nextItem: TimelineItem = firstItem
        
        for item in timelineItems {
            if time > item.getDate(for: time) {
                returnItem = item
            } else {
                nextItem = item
                break
            }
        }
        
        return .during(item: returnItem, nextItem: nextItem)
    }
    
    func markConflicts() {
        let initialConflicts = getConflicts()
        var lastDate: Date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        for item in timelineItems {
            if lastDate > item.getDate() {
                item.isConflicted = true
            } else {
                item.isConflicted = false
            }
            lastDate = item.getDate()
        }
        if getConflicts() != initialConflicts {
            NotificationCenter.default.post(name: Notification.Name("ConflictChange"), object: nil)
        }
        save()
    }
    
    func getConflicts() -> Int {
        var conflicts = 0
        for item in timelineItems {
            if item.isConflicted {
                conflicts += 1
            }
        }
        return conflicts
    }
    
    func copyItems(from timeline: Timeline) {
        timelineItems = []
        for item in timeline.timelineItems {
            timelineItems.append(item.copy() as! TimelineItem)
        }
    }
    
    func save() {
        if key != "" {
            let defaults = UserDefaults.init(suiteName: "group.com.benk.timetinerary")
            defaults?.setValue(TimelineItem.getData(array: timelineItems), forKey: key)
            hasChanged()
        }
    }
}

func sampleTimeline() -> Timeline {
    var items: [TimelineItem] = []
    
    items.append(TimelineItem(name: "Period 1", hour: 7, minute: 00))
    items.append(TimelineItem(name: "Period 3", hour: 8, minute: 00))
    items.append(TimelineItem(name: "Atech Time", hour: 9, minute: 00))
    items.append(TimelineItem(name: "Lunch", hour: 10, minute: 00))
    items.append(TimelineItem(name: "Period 5", hour: 11, minute: 00))
    items.append(TimelineItem(name: "Period 7", hour: 12, minute: 00))
    
    return Timeline(items: items)
}
