//
//  Week.swift
//  Timetinerary
//
//  Created by Ben K on 10/6/21.
//

import SwiftUI

enum WeekDays: String, CaseIterable, Equatable {
    case M, T, W, Th, F, Sa, S
    
    var id: String { self.rawValue.capitalized }
    
    var int: Int {
        switch self {
        case .M:
            return 0
        case .T:
            return 1
        case .W:
            return 2
        case .Th:
            return 3
        case .F:
            return 4
        case .Sa:
            return 5
        case .S:
            return 6
        }
    }
    
    static func convertComponent(weekDay: Int) -> WeekDays {
        switch weekDay {
        case 1:
            return .S
        case 2:
            return .M
        case 3:
            return .T
        case 4:
            return .W
        case 5:
            return .Th
        case 6:
            return .F
        case 7:
            return .Sa
        default:
            return .S
        }
    }
    
    static func fromDate(_ date: Date) -> WeekDays {
        let weekDay = Calendar.current.component(.weekday, from: date)
        return convertComponent(weekDay: weekDay)
    }
    
    static func fromInt(_ int: Int) -> WeekDays {
        switch int {
        case 0:
            return .M
        case 1:
            return .T
        case 2:
            return .W
        case 3:
            return .Th
        case 4:
            return .F
        case 5:
            return .Sa
        case 6:
            return .S
        default:
            return .M
        }
    }
    
    func shiftForwards() -> WeekDays {
        let newInt = (self.int + 1) % 7
        return WeekDays.fromInt(newInt)
    }
    
    func shiftBackwards() -> WeekDays {
        let newInt = (self.int - 1) % 7
        return WeekDays.fromInt(newInt)
    }
}

func weekDayName(for weekDay: WeekDays) -> String {
    switch weekDay {
    case .M:
        return "Monday"
    case .T:
        return "Tuesday"
    case .W:
        return "Wednesday"
    case .Th:
        return "Thursday"
    case .F:
        return "Friday"
    case .Sa:
        return "Saturday"
    case .S:
        return "Sunday"
    }
}

func weekDayImage(for weekDay: WeekDays) -> String {
    switch weekDay {
    case .M:
        return "1.circle"
    case .T:
        return "2.circle"
    case .W:
        return "3.circle"
    case .Th:
        return "4.circle"
    case .F:
        return "5.circle"
    case .Sa:
        return "6.circle"
    case .S:
        return "7.circle"
    }
}
