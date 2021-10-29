//
//  TimeView.swift
//  Watch WatchKit Extension
//
//  Created by Ben K on 10/19/21.
//

import SwiftUI

struct TimeView: View {
    @StateObject var timelineWeek: TimelineWeek
    @State private var date = Date()
    
    var timeline: Timeline {
        timelineWeek.getTimeline(date: date)
    }
    
    var moment: TimelineMoment {
        timeline.getMoment(at: date)
    }
    
    let timer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Text("\(date)")
                .hidden()
            
            switch moment {
            case .conflicts:
                ConflictsView()
            case .before(let firstItem):
                BeforeView(firstItem: firstItem)
            case .after:
                AfterView()
            case .during(let item, let nextItem):
                DuringView(item: item, nextItem: nextItem)
            case .empty:
                DayOffView(daysSince: timelineWeek.daysTill(date: date, direction: .backward), daysUntil: timelineWeek.daysTill(date: date, direction: .forward))
            }
        }
        .onReceive(timer) { _ in
            self.date = Date()
        }
    }
    
    struct DuringView: View {
        @EnvironmentObject var userColors: UserColors
        let item: TimelineItem
        let nextItem: TimelineItem
        
        var title: String { item.name }
        
        var backgroundColor: Color { userColors.duringBG }
        var foregroundColor: Color { userColors.duringFG }
        var textColor: Color { userColors.duringText }
        
        var start: Date { item.getDate() }
        var end: Date { nextItem.getDate() }
        
        var startText: String { item.getTimeString() }
        var endText: String { nextItem.getTimeString() }
        
        var circleType: CircleType { .percentage(start, end, foregroundColor) }
        var headerType: HeaderType { .span(startText, endText) }
        var subType: SubType { .description("Ends in ", end) }
        
        
        var body: some View {
            TimeCircle(title: title, backgroundColor: backgroundColor, textColor: textColor, circle: circleType, header: headerType, subheader: subType)
        }
    }
    
    struct BeforeView: View {
        @EnvironmentObject var userColors: UserColors
        @StateObject var firstItem: TimelineItem
        
        var title: String { firstItem.name }
        
        var backgroundColor: Color { userColors.beforeBG }
        var textColor: Color { userColors.beforeText }
        
        var end: Date { firstItem.getDate() }
        
        var subType: SubType { .description("Starts in ", end)}
        
        var body: some View {
            TimeCircle(title: title, backgroundColor: backgroundColor, textColor: textColor, subheader: subType)
        }
    }
    
    struct AfterView: View {
        @EnvironmentObject var userColors: UserColors
        
        var title = "Schedule Over"
        
        var backgroundColor: Color { userColors.afterBG }
        var textColor: Color { userColors.afterText }
        
        
        var body: some View {
            TimeCircle(title: title, backgroundColor: backgroundColor, textColor: textColor)
        }
    }
    
    struct DayOffView: View {
        @EnvironmentObject var userColors: UserColors
        let daysSince: Int?
        let daysUntil: Int?
        
        var title = "Day Off"
        
        var backgroundColor: Color { userColors.dayOffBG }
        var foregroundColor: Color { userColors.dayOffFG }
        var textColor: Color { userColors.dayOffText }
        
        var body: some View {
            if let daysSince = daysSince, let daysUntil = daysUntil, daysSince - 1 >= 0 {
                
                let calendar = Calendar.current
                let unshiftedDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
                let start = calendar.date(byAdding: .day, value: -1 * (daysSince - 1), to: unshiftedDate)!
                let end = calendar.date(byAdding: .day, value: daysUntil, to: unshiftedDate)!
                
                let circleType: CircleType = .percentage(start, end, foregroundColor)
                let subType: SubType = .description("Ends in ", end)
                
                TimeCircle(title: title, backgroundColor: backgroundColor, textColor: textColor, circle: circleType, subheader: subType)
            } else {
                TimeCircle(title: title, backgroundColor: backgroundColor, textColor: textColor)
            }
        }
    }
    
    enum CircleType {
        case backgroundOnly
        case percentage(Date, Date, Color)
    }
    
    enum HeaderType {
        case date
        case span(String, String)
    }
    
    enum SubType {
        case blank
        case description(String, Date)
    }
    
    struct TimeCircle: View {
        let title: String
        let backgroundColor: Color
        let textColor: Color
        var circle: CircleType = .backgroundOnly
        var header: HeaderType = .date
        var subheader: SubType = .blank
        
        @State private var refreshDate = Date()
        let timer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
        
        var body: some View {
            ZStack {
                ZStack {
                    Text("\(refreshDate)")
                        .hidden()
                    
                    Circle()
                        .foregroundColor(backgroundColor)
                    
                    if case .percentage(let start, let end, let foreground) = circle {
                        let total = end.timeIntervalSince(start)
                        let elapsed = Date().timeIntervalSince(start)
                        let percentage = elapsed / total
                        
                        Circle()
                            .trim(from: 0, to: percentage)
                            .rotation(.degrees(-90))
                            .stroke(foreground, lineWidth: 5)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    }
                }
                //.shadow(radius: 20)
                
                VStack(alignment: .leading, spacing: 5) {
                    if case .span(let start, let end) = header {
                        Text("\(start) - \(end)")
                            .font(.system(size: 5, weight: .regular, design: .rounded))
                            .fontWeight(.medium)
                    } else {
                        Text(Date(), style: .time)
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(.medium)
                    }
                    
                    Text(title)
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Group {
                        if case .description(let text, let date) = subheader {
                            Text(text)
                            +
                            Text(date, style: .relative)
                        }
                    }
                    .font(.system(.body, design: .rounded))
                }
                .padding(5)
                .padding(.horizontal, 10)
                .foregroundColor(textColor)
            }
            .onReceive(timer) { _ in
                refreshDate = Date()
            }
        }
    }
    
    struct ConflictsView: View {
        var body: some View {
            VStack(spacing: 7) {
                Spacer()
                Image(systemName: "exclamationmark.circle")
                    .font(.system(size: 50, weight: .regular, design: .rounded))
                    .padding(.bottom, 5)
                Text("Conflicts Detected")
                    .font(.system(.headline, design: .rounded))
                Text("Please fix the time conflicts on today's table.")
                    .italic()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .font(.system(.footnote, design: .rounded))
                Spacer()
            }
            .foregroundColor(.red)
            .padding()
        }
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView(timelineWeek: TimelineWeek())
    }
}
