//
//  TimeView.swift
//  Timetinerary
//
//  Created by Ben K on 10/7/21.
//

import SwiftUI
import Combine

struct TimeView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var timelineWeek: TimelineWeek
    @State private var date = Date()
    
    var timeline: Timeline {
        timelineWeek.getTimeline(date: date)
    }
    
    let timer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                Text("\(date)")
                    .hidden()
                
                switch timeline.getMoment(at: Date()) {
                case .conflicts:
                    ConflictsView()
                case .before(let firstItem):
                    BeforeView(firstItem: firstItem)
                case .after:
                    AfterView()
                case .during(let item, let nextItem):
                    DuringView(item: item, nextItem: nextItem)
                case .empty:
                    DayOffView(daysSince: timelineWeek.daysTill(date: date, direction: .backward), daysUntil: timelineWeek.daysTill(date: date, direction: .backward))
                }
            }
            .offset(x: 0, y: -20)
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(timer) { _ in
                self.date = Date()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    struct DuringView: View {
        @EnvironmentObject var userColors: UserColors
        @StateObject var item: TimelineItem
        @StateObject var nextItem: TimelineItem
        
        @State private var date = Date()
        let timer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
        
        var percentageElapsed: Double {
            let total = nextItem.getDate().timeIntervalSince(item.getDate())
            let elapsed = Date().timeIntervalSince(item.getDate())
            return elapsed / total
        }
        
        var body: some View {
            ZStack {
                ZStack {
                    Text("\(date)")
                        .hidden()
                    
                    Circle()
                        .foregroundColor(userColors.duringBG)
                    
                    Circle()
                        .trim(from: 0, to: percentageElapsed)
                        .rotation(.degrees(-90))
                        .stroke(userColors.duringFG, lineWidth: 5)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
                .padding()
                .padding()
                .padding(.vertical)
                .shadow(radius: 20)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(item.getTimeString()) - \(nextItem.getTimeString())")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.medium)
                    
                    Text(item.name)
                        .font(.system(size: 50, weight: .medium, design: .rounded))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Group {
                        Text("Ends in ")
                        +
                        
                        Text(nextItem.getDate(), style: .relative)
                    }
                }
                .font(.system(.body, design: .rounded))
                .padding(5)
                .padding(.horizontal, 60)
                .foregroundColor(userColors.duringText)
            }
            .onReceive(timer) { _ in
                date = Date()
            }
        }
    }
    
    struct BeforeView: View {
        @EnvironmentObject var userColors: UserColors
        @StateObject var firstItem: TimelineItem
        
        var body: some View {
            ZStack {
                Circle()
                    .padding()
                    .padding()
                    .padding(.vertical)
                    .foregroundColor(userColors.beforeBG)
                    .shadow(radius: 20)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(Date(), style: .time)
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.medium)
                    
                    Text(firstItem.name)
                        .font(.system(size: 50, weight: .regular, design: .rounded))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Group {
                        Text("Starts in ")
                            .italic()
                        +
                        
                        Text(firstItem.getDate(), style: .relative)
                            .italic()
                    }
                }
                .padding(5)
                .padding(.horizontal, 60)
                .foregroundColor(userColors.beforeText)
            }
        }
    }
    
    struct AfterView: View {
        @EnvironmentObject var userColors: UserColors
        
        var body: some View {
            ZStack {
                Circle()
                    .padding()
                    .padding()
                    .padding(.vertical)
                    .foregroundColor(userColors.afterBG)
                    .shadow(radius: 20)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(Date(), style: .time)
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.medium)
                    
                    Text("Schedule Over")
                        .font(.system(size: 50, weight: .regular, design: .rounded))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
                .padding(5)
                .padding(.horizontal, 60)
                .foregroundColor(userColors.afterText)
            }
        }
    }
    
    struct DayOffView: View {
        @EnvironmentObject var userColors: UserColors
        let daysSince: Int?
        let daysUntil: Int?
        
        var body: some View {
            if let daysSince = daysSince, let daysUntil = daysUntil {
                NonEmptyWeek(daysSince: daysSince, daysUntil: daysUntil)
            } else {
                EmptyWeek()
            }
        }
        
        struct NonEmptyWeek: View {
            @EnvironmentObject var userColors: UserColors
            let daysSince: Int
            let daysUntil: Int
            
            var startTime: Date {
                if daysSince - 1 >= 0 {
                    let calendar = Calendar.current
                    let unshiftedDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
                    return calendar.date(byAdding: .day, value: -1 * (daysSince - 1), to: unshiftedDate)!
                } else {
                    return Date()
                }
            }
            var endTime: Date {
                if daysSince - 1 >= 0 {
                    let calendar = Calendar.current
                    let unshiftedDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
                    return calendar.date(byAdding: .day, value: daysUntil, to: unshiftedDate)!
                } else {
                    return Date()
                }
            }
            
            @State private var date = Date()
            let timer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
            
            var percentageElapsed: Double {
                let total = endTime.timeIntervalSince(startTime)
                let elapsed = Date().timeIntervalSince(startTime)
                return elapsed / total
            }
            
            var body: some View {
                ZStack {
                    ZStack {
                        Text("\(date)")
                            .hidden()
                        
                        Circle()
                            .foregroundColor(userColors.dayOffBG)
                        
                        Circle()
                            .trim(from: 0, to: percentageElapsed)
                            .rotation(.degrees(-90))
                            .stroke(userColors.dayOffFG, lineWidth: 5)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    }
                    .padding()
                    .padding()
                    .padding(.vertical)
                    .shadow(radius: 20)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(Date(), style: .time)
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(.medium)
                        
                        Text("Day Off")
                            .font(.system(size: 50, weight: .medium, design: .rounded))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        
                        Group {
                            Text("Ends in ")
                            +
                            
                            Text(endTime, style: .relative)
                        }
                    }
                    .font(.system(.body, design: .rounded))
                    .padding(5)
                    .padding(.horizontal, 60)
                    .foregroundColor(userColors.dayOffText)
                }
                .onReceive(timer) { _ in
                    date = Date()
                }
            }
        }
        
        struct EmptyWeek: View {
            @EnvironmentObject var userColors: UserColors
            
            var body: some View {
                ZStack {
                    Circle()
                        .padding()
                        .padding()
                        .padding(.vertical)
                        .foregroundColor(userColors.dayOffBG)
                        .shadow(radius: 20)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(Date(), style: .time)
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(.medium)
                        
                        Text("Empty Week")
                            .font(.system(size: 50, weight: .regular, design: .rounded))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }
                    .padding(5)
                    .padding(.horizontal, 60)
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
