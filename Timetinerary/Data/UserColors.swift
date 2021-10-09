//
//  UserColors.swift
//  Timetinerary
//
//  Created by Ben K on 10/7/21.
//

import SwiftUI
import WidgetKit

enum UserColorTypes: String, Equatable {
    case beforeBG, beforeText, duringBG, duringFG, duringText, afterBG, afterText, dayOffBG, dayOffFG, dayOffText
    
    var assetText: String {
        switch self {
        case .beforeBG:
            return "BeforeBG"
        case .beforeText:
            return "BeforeText"
        case .duringBG:
            return "DuringBG"
        case .duringFG:
            return "DuringFG"
        case .duringText:
            return "DuringText"
        case .afterBG:
            return "AfterBG"
        case .afterText:
            return "AfterText"
        case .dayOffBG:
            return "DayOffBG"
        case .dayOffFG:
            return "DayOffFG"
        case .dayOffText:
            return "DayOffText"
        }
    }
}

class UserColors: ObservableObject, Codable {
    @Published var beforeBG: Color { didSet { save() } }
    @Published var beforeText: Color { didSet { save() } }
    
    @Published var duringBG: Color { didSet { save() } }
    @Published var duringFG: Color { didSet { save() } }
    @Published var duringText: Color { didSet { save() } }
    
    @Published var afterBG: Color { didSet { save() } }
    @Published var afterText: Color { didSet { save() } }
    
    @Published var dayOffBG: Color { didSet { save() } }
    @Published var dayOffFG: Color { didSet { save() } }
    @Published var dayOffText: Color { didSet { save() } }
    
    var key: String
    
    init(key: String = "defaultUserColors") {
        let defaults = UserDefaults.init(suiteName: "group.com.benk.timetinerary")
        
        let colorData: UserColors? = UserColors.getUserColors(from: defaults?.data(forKey: key) ?? Data())
        
        self.beforeBG = colorData?.beforeBG ?? Color("BeforeBG")
        self.beforeText = colorData?.beforeText ?? Color("BeforeText")
        
        self.duringBG = colorData?.duringBG ?? Color("DuringBG")
        self.duringFG = colorData?.duringFG ?? Color("DuringFG")
        self.duringText = colorData?.duringText ?? Color("DuringText")
        
        self.afterBG = colorData?.afterBG ?? Color("AfterBG")
        self.afterText = colorData?.afterText ?? Color("AfterText")
        
        self.dayOffBG = colorData?.dayOffBG ?? Color("DayOffBG")
        self.dayOffFG = colorData?.dayOffFG ?? Color("DayOffFG")
        self.dayOffText = colorData?.dayOffText ?? Color("DayOffText")
        
        self.key = key
    }
    
    func save() {
        if key != "" {
            let defaults = UserDefaults.init(suiteName: "group.com.benk.timetinerary")
            defaults?.setValue(self.getData(), forKey: key)
        }
        WidgetCenter.shared.reloadAllTimelines()
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
    
    static func getUserColors(from data: Data) -> UserColors? {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(UserColors.self, from: data)
        } catch {
            print("Could not decode \(data)")
            return nil
        }
    }
    
    enum CodingKeys: CodingKey {
        case beforeBG, beforeText, duringBG, duringFG, duringText, afterBG, afterText, dayOffBG, dayOffFG, dayOffText, key
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(beforeBG, forKey: .beforeBG)
        try container.encode(beforeText, forKey: .beforeText)
        
        try container.encode(duringBG, forKey: .duringBG)
        try container.encode(duringFG, forKey: .duringFG)
        try container.encode(duringText, forKey: .duringText)
        
        try container.encode(afterBG, forKey: .afterBG)
        try container.encode(afterText, forKey: .afterText)
        
        try container.encode(dayOffBG, forKey: .dayOffBG)
        try container.encode(dayOffFG, forKey: .dayOffFG)
        try container.encode(dayOffText, forKey: .dayOffText)
        
        try container.encode(key, forKey: .key)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        beforeBG = try container.decode(Color.self, forKey: .beforeBG)
        beforeText = try container.decode(Color.self, forKey: .beforeText)
        
        duringBG = try container.decode(Color.self, forKey: .duringBG)
        duringFG = try container.decode(Color.self, forKey: .duringFG)
        duringText = try container.decode(Color.self, forKey: .duringText)
        
        afterBG = try container.decode(Color.self, forKey: .afterBG)
        afterText = try container.decode(Color.self, forKey: .afterText)
        
        dayOffBG = try container.decode(Color.self, forKey: .dayOffBG)
        dayOffFG = try container.decode(Color.self, forKey: .dayOffFG)
        dayOffText = try container.decode(Color.self, forKey: .dayOffText)
        
        key = try container.decode(String.self, forKey: .key)
    }
}
