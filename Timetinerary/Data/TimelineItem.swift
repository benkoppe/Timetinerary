//
//  TimelineItem.swift
//  Timetinerary
//
//  Created by Ben K on 10/6/21.
//

import SwiftUI

class TimelineItem: ObservableObject, Codable, Equatable, Identifiable, NSCopying {
    @Published var name: String
    @Published var hour: Int
    @Published var minute: Int
    @Published var isConflicted: Bool
    
    let id: UUID
    
    init(name: String, hour: Int, minute: Int, isConflicted: Bool = false) {
        self.name = name
        self.hour = hour
        self.minute = minute
        self.isConflicted = isConflicted
        
        id = UUID()
    }
    
    static func == (lhs: TimelineItem, rhs: TimelineItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = TimelineItem(name: name, hour: hour, minute: minute, isConflicted: isConflicted)
        return copy
    }
    
    enum CodingKeys: CodingKey {
        case name, hour, minute, isConflicted, id
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(hour, forKey: .hour)
        try container.encode(minute, forKey: .minute)
        try container.encode(isConflicted, forKey: .isConflicted)
        
        try container.encode(id, forKey: .id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        hour = try container.decode(Int.self, forKey: .hour)
        minute = try container.decode(Int.self, forKey: .minute)
        isConflicted = try container.decode(Bool.self, forKey: .isConflicted)
        
        id = try container.decode(UUID.self, forKey: .id)
    }
    
    func setTime(from date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        self.hour = components.hour ?? 0
        self.minute = components.minute ?? 0
        
        self.objectWillChange.send()
    }
    
    func getDate() -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: self.hour, minute: self.minute, second: 0, of: Date()) ?? Date()
    }
    
    func getDate(for date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: self.hour, minute: self.minute, second: 0, of: date) ?? Date()
    }
    
    func getTimeString() -> String {
        let date = self.getDate()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
    
    func getData() -> Data {
        do {
            let encoder = JSONEncoder()
            return try encoder.encode(self)
        } catch {
            print("Could not encode \(self)")
            return Data()
        }
    }
    
    static func getTimelineItem(from data: Data) -> TimelineItem? {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(TimelineItem.self, from: data)
        } catch {
            print("Could not decode \(data)")
            return nil
        }
    }
    
    static func getData(array: [TimelineItem]) -> [Data] {
        var arr: [Data] = []
        for timelineItem in array {
            arr.append(timelineItem.getData())
        }
        return arr
    }
}
