//
//  TimeTable.swift
//  Timetinerary
//
//  Created by Ben K on 10/6/21.
//

import SwiftUI

struct TimeTable: View {
    @EnvironmentObject var timelineWeek: TimelineWeek
    @ObservedObject var timeline = sampleTimeline()
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                Spacer().frame(height: 20)
                
                if timeline.timelineItems.count > 1 {
                    ForEach($timeline.timelineItems) { $item in
                        TimeRow(item: item)
                            .padding(1)
                        if item != timeline.timelineItems.last {
                            NameRow(item: item)
                        }
                    }
                    .listRowSeparator(.hidden)
                } else {
                    Text("*No schedule today.*")
                        .onAppear { timeline.timelineItems = []; timelineWeek.objectWillChange.send() }
                }
                
                Button {
                    var hour = (timeline.timelineItems.last?.hour ?? 6) + 1
                    var minute = timeline.timelineItems.last?.minute ?? 25
                    if hour > 23 { hour = 23; minute = 59 }
                    withAnimation {
                        timeline.timelineItems.append(TimelineItem(name: "", hour: hour, minute: minute))
                        if timeline.timelineItems.count < 2 {
                            timeline.timelineItems.append(TimelineItem(name: "", hour: hour + 1, minute: minute))
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { withAnimation { proxy.scrollTo(1) } }
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .padding()
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .id(1)
            }
            .padding(.horizontal)
            .environmentObject(timeline)
        }
    }
    
    struct NameRow: View {
        @EnvironmentObject var timelineWeek: TimelineWeek
        @EnvironmentObject var timeline: Timeline
        @StateObject var item: TimelineItem
        
        @State private var removeWarning = false
        
        var body: some View {
            HStack {
                Capsule()
                    .padding(.leading)
                    .frame(width: 2, height: 50)
                    .background(Color.primary)
                    .padding(.vertical, 5)
                TextField("Name", text: $item.name)
                    .labelsHidden()
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading, 10)
                Spacer()
                Button(role: .destructive) {
                    removeWarning = true
                } label: {
                    Image(systemName: "trash")
                        .padding(.horizontal)
                }
                Spacer()
            }
            .padding(.leading, 30)
            .onChange(of: item.name) { _ in
                timeline.save()
                timelineWeek.objectWillChange.send()
            }
            .confirmationDialog("Are you sure you want to delete this row?", isPresented: $removeWarning) {
                Button("Remove", role: .destructive) {
                    withAnimation {
                        timeline.timelineItems.removeAll(where: {$0.id == item.id})
                        timelineWeek.objectWillChange.send()
                    }
                }
            }
        }
    }
    
    struct TimeRow: View {
        @EnvironmentObject var timelineWeek: TimelineWeek
        @EnvironmentObject var timeline: Timeline
        @StateObject var item: TimelineItem
        @State private var time: Date = Date()
        
        var body: some View {
            HStack {
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                if item.isConflicted {
                    Image(systemName: "exclamationmark.circle")
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .onAppear {
                time = item.getDate()
                time = item.getDate()
                timeline.markConflicts()
                timeline.save()
            }
            .onChange(of: time) { newValue in
                item.setTime(from: newValue)
                timeline.save()
                timeline.markConflicts()
                timelineWeek.objectWillChange.send()
            }
        }
    }
}

struct TimeTable_Previews: PreviewProvider {
    static var previews: some View {
        TimeTable()
    }
}
