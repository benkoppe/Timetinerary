//
//  TimeWidget.swift
//  TimeWidget
//
//  Created by Ben K on 10/8/21.
//

import WidgetKit
import SwiftUI

typealias WidgetTimeline = WidgetKit.Timeline

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), timelineWeek: TimelineWeek(), userColors: UserColors())
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = Entry(date: Date(), timelineWeek: TimelineWeek(), userColors: UserColors())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (WidgetTimeline<Entry>) -> ()) {
//        var entries: [Entry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = Entry(date: entryDate, timelineWeek: TimelineWeek(), userColors: UserColors())
//            entries.append(entry)
//        }
        let entry = Entry(date: Date(), timelineWeek: TimelineWeek(), userColors: UserColors())
        let timeline = WidgetTimeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct Entry: TimelineEntry {
    let date: Date
    let timelineWeek: TimelineWeek
    let userColors: UserColors
}

struct TimeWidgetEntryView : View {
    let entry: Entry
    
    var timeline: Timeline {
        entry.timelineWeek.getTimeline(date: entry.date)
    }
    
    var body: some View {
        Group {
            switch timeline.getMoment(at: entry.date) {
            case .conflicts:
                ConflictsView()
            case .before(let firstItem):
                BeforeView(firstItem: firstItem, date: entry.date)
            case .after:
                AfterView(date: entry.date)
            case .during(let item, let nextItem):
                DuringView(item: item, nextItem: nextItem, date: entry.date)
            case .empty:
                let daysSince = entry.timelineWeek.daysTill(date: entry.date, direction: .backward)
                let daysUntil = entry.timelineWeek.daysTill(date: entry.date, direction: .backward)
                DayOffView(daysSince: daysSince, daysUntil: daysUntil, date: entry.date)
            }
        }
        .environmentObject(entry.userColors)
    }
    
    struct DuringView: View {
        @EnvironmentObject var userColors: UserColors
        @StateObject var item: TimelineItem
        @StateObject var nextItem: TimelineItem
        
        let date: Date
        
        var percentageElapsed: Double {
            let total = nextItem.getDate().timeIntervalSince(item.getDate())
            let elapsed = date.timeIntervalSince(item.getDate())
            return elapsed / total
        }
        
        var body: some View {
            ZStack {
                GeometryReader { geo in
                    userColors.duringBG
                    
                    HStack {
                        userColors.duringFG
                            .frame(width: geo.size.width * percentageElapsed)
                        
                        Spacer()
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(item.getTimeString()) - \(nextItem.getTimeString())")
                        .widgetText(.header)
                    
                    Text(item.name)
                        .widgetText(.main)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Group {
                        Text("Ends in ")
                        +
                        Text(nextItem.getDate(), style: .relative)
                    }
                    .widgetText(.subheader)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                }
                .padding(15)
                .foregroundColor(userColors.duringText)
            }
        }
    }
    
    struct BeforeView: View {
        @EnvironmentObject var userColors: UserColors
        @StateObject var firstItem: TimelineItem
        
        let date: Date
        
        var body: some View {
            ZStack {
                userColors.beforeBG
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(date, style: .time)
                        .widgetText(.header)
                    
                    Text(firstItem.name)
                        .widgetText(.main)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Group {
                        Text("Starts in ")
                            .italic()
                        +
                        
                        Text(firstItem.getDate(), style: .relative)
                            .italic()
                    }
                    .widgetText(.subheader)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                }
                .padding(15)
                .foregroundColor(userColors.beforeText)
            }
        }
    }
    
    struct AfterView: View {
        @EnvironmentObject var userColors: UserColors
        
        let date: Date
        
        var body: some View {
            ZStack {
                userColors.afterBG
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(date, style: .time)
                        .widgetText(.header)
                    
                    Text("Schedule Over")
                        .widgetText(.main, sizeChange: 3)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                .padding(15)
                .foregroundColor(userColors.afterText)
            }
        }
    }
    
    struct DayOffView: View {
        @EnvironmentObject var userColors: UserColors
        let daysSince: Int?
        let daysUntil: Int?
        
        let date: Date
        
        var body: some View {
            if let daysSince = daysSince, let daysUntil = daysUntil {
                NonEmptyWeek(daysSince: daysSince, daysUntil: daysUntil, date: date)
            } else {
                EmptyWeek(date: date)
            }
        }
        
        struct NonEmptyWeek: View {
            @EnvironmentObject var userColors: UserColors
            
            let daysSince: Int
            let daysUntil: Int
            
            let date: Date
            
            var startTime: Date {
                if daysSince - 1 >= 0 {
                    let calendar = Calendar.current
                    let unshiftedDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
                    return calendar.date(byAdding: .day, value: -1 * (daysSince - 1), to: unshiftedDate)!
                } else {
                    return date
                }
            }
            var endTime: Date {
                if daysSince - 1 >= 0 {
                    let calendar = Calendar.current
                    let unshiftedDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
                    return calendar.date(byAdding: .day, value: daysUntil, to: unshiftedDate)!
                } else {
                    return date
                }
            }
            
            var percentageElapsed: Double {
                let total = endTime.timeIntervalSince(startTime)
                let elapsed = date.timeIntervalSince(startTime)
                return elapsed / total
            }
            
            var body: some View {
                ZStack {
                    GeometryReader { geo in
                        userColors.dayOffBG
                        
                        HStack {
                            userColors.dayOffFG
                                .frame(width: geo.size.width * percentageElapsed)
                            
                            Spacer()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(date, style: .time)
                            .widgetText(.header)
                        
                        Text("Day Off")
                            .widgetText(.main, sizeChange: -2)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        
                        Group {
                            Text("Ends in ")
                            +
                            Text(endTime, style: .relative)
                        }
                        .widgetText(.subheader)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    }
                    .padding(15)
                    .foregroundColor(userColors.dayOffText)
                }
            }
        }
        
        struct EmptyWeek: View {
            @EnvironmentObject var userColors: UserColors
            
            let date: Date
            
            var body: some View {
                ZStack {
                    userColors.dayOffBG
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(date, style: .time)
                            .widgetText(.header)
                        
                        Text("Empty Week")
                            .widgetText(.main, sizeChange: 3)
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)
                    }
                    .padding(15)
                    .foregroundColor(userColors.dayOffText)
                }
            }
        }
    }
    
    struct ConflictsView: View {
        var body: some View {
            VStack(spacing: 7) {
                Spacer()
                Image(systemName: "exclamationmark.circle")
                    .widgetText(.main)
                Text("Conflicts Detected")
                    .widgetText(.subheader)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .foregroundColor(.red)
            .padding()
        }
    }
}

enum TextType {
    case header, main, subheader
}
struct WidgetText: ViewModifier {
    let type: TextType
    let sizeChange: CGFloat
    
    func body(content: Content) -> some View {
        switch type {
        case .header:
            content
                .font(.system(size: 8 + sizeChange, weight: .semibold, design: .rounded))
        case .main:
            content
                .font(.system(size: 27 + sizeChange, weight: .bold, design: .rounded))
        case .subheader:
            content
                .font(.system(size: 16 + sizeChange, weight: .medium, design: .rounded))
        }
    }
}

extension View {
    func widgetText(_ type: TextType, sizeChange: CGFloat = 0) -> some View {
        self.modifier(WidgetText(type: type, sizeChange: sizeChange))
    }
}

@main
struct TimeWidget: Widget {
    let kind: String = "TimeWidget"
    let provider = Provider()

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: provider) { entry in
            TimeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Timetinerary")
        .description("Displays your current timeline.")
        .supportedFamilies([.systemSmall])
    }
}

struct TimeWidget_Previews: PreviewProvider {
    static var previews: some View {
        TimeWidgetEntryView(entry: Entry(date: Date(), timelineWeek: TimelineWeek(), userColors: UserColors()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
