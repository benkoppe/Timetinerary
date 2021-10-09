//
//  Week.swift
//  Timetinerary
//
//  Created by Ben K on 10/6/21.
//

import Foundation
import WidgetKit

class TimelineWeek: ObservableObject, Identifiable {
    @Published var week: [Timeline]
    var key: String
    
    var conflicts: Int {
        var conflicts = 0
        for day in WeekDays.allCases {
            conflicts += getTimeline(day: day).getConflicts()
        }
        return conflicts
    }
    
    init(key: String = "defaultWeek") {
        let MWeek = Timeline(key: key + WeekDays.M.rawValue)
        let TWeek = Timeline(key: key + WeekDays.T.rawValue)
        let WWeek = Timeline(key: key + WeekDays.W.rawValue)
        let ThWeek = Timeline(key: key + WeekDays.Th.rawValue)
        let FWeek = Timeline(key: key + WeekDays.F.rawValue)
        let SaWeek = Timeline(key: key + WeekDays.Sa.rawValue)
        let SWeek = Timeline(key: key + WeekDays.S.rawValue)
        
        self.week = [MWeek, TWeek, WWeek, ThWeek, FWeek, SaWeek, SWeek]
        self.key = key
    }
    
    func saveAll() {
        for timeline in week {
            timeline.save()
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func getTimeline(day: WeekDays) -> Timeline {
        switch day {
        case .M:
            return week[0]
        case .T:
            return week[1]
        case .W:
            return week[2]
        case .Th:
            return week[3]
        case .F:
            return week[4]
        case .Sa:
            return week[5]
        case .S:
            return week[6]
        }
    }
    
    func getTimeline(date: Date) -> Timeline {
        let day = WeekDays.fromDate(date)
        return getTimeline(day: day)
    }
    
    func daysTill(date: Date, direction: Calendar.SearchDirection) -> Int? {
        var days = 0
        var checkDay = date
        for _ in WeekDays.allCases {
            if getTimeline(date: checkDay).timelineItems.count >= 2 {
                return days
            } else {
                days += 1
                checkDay = Calendar.current.date(byAdding: .day, value: direction == .forward ? 1 : -1, to: checkDay)!
            }
        }
        return nil
    }
}
