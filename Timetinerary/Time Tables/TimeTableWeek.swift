//
//  TimeTableWeek.swift
//  Timetinerary
//
//  Created by Ben K on 10/6/21.
//

import SwiftUI

struct TimeTableWeek: View {
    @State private var weekDay: WeekDays = .M
    @ObservedObject var timelineWeek: TimelineWeek = TimelineWeek()
    
    @AppStorage("defaultSaved", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var savedKeys: [String] = []
    
    @State private var saveTable = false
    @State private var saveFailure = false
    @State private var deleteAll = false
    
    @State private var showingTime = false
    @State private var showingSettings = false
    
    var conflicts: Int {
        timelineWeek.conflicts
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TimeTable(timeline: timelineWeek.getTimeline(day: weekDay))
                    .alert(isPresented: $saveTable,
                           TextAlert(title: "Save Table", message: "Please enter a name for this time table.", keyboardType: .default) { result in
                        if let result = result {
                            if !savedKeys.contains(result), !result.isEmpty {
                                let newTimeline = Timeline(key: result)
                                newTimeline.copyItems(from: timelineWeek.getTimeline(day: weekDay))
                                savedKeys.append(result)
                            } else if !result.isEmpty {
                                saveFailure = true
                            }
                        }
                    })
            }
            .environmentObject(timelineWeek)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("\(weekDayName(for: weekDay))")
            .onAppear {
                weekDay = WeekDays.fromDate(Date())
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Picker("Week Day", selection: $weekDay) {
                        ForEach(WeekDays.allCases, id: \.self) {
                            Text($0.id)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                    .scaleEffect(0.9)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if !(conflicts > 0) {
                        Button {
                            showingTime = true
                        } label: {
                            Image(systemName: "deskclock")
                        }
                    } else {
                        Text("\(Image(systemName: "exclamationmark.circle")) \(conflicts) \(conflicts == 1 ? "conflict" : "conflicts")")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    MoreMenu(weekDay: $weekDay, timelineWeek: timelineWeek, saveTable: $saveTable, saveFailure: $saveFailure, deleteAll: $deleteAll, showingSettings: $showingSettings)
                }
            }
            .sheet(isPresented: $showingTime) {
                TimeView(timelineWeek: timelineWeek)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .alert("Save Error", isPresented: $saveFailure) {
            } message: {
                Text("Sorry, there was an error saving your table. Make sure the name you selected is unique.\n\nIf this issue persists, please contact the developer.")
            }
            .confirmationDialog("Are you sure you want to clear this table?", isPresented: $deleteAll) {
                Button("Clear All", role: .destructive) {
                    withAnimation {
                        timelineWeek.getTimeline(day: weekDay).timelineItems = []
                        timelineWeek.objectWillChange.send()
                    }
                }
            }
        }
    }
    
    struct MoreMenu: View {
        @Binding var weekDay: WeekDays
        @StateObject var timelineWeek: TimelineWeek = TimelineWeek()
        
        @AppStorage("defaultSaved", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var savedKeys: [String] = []
        
        @Binding var saveTable: Bool
        @Binding var saveFailure: Bool
        @Binding var deleteAll: Bool
        
        @Binding var showingSettings: Bool
        
        var body: some View {
            Menu {
                Menu {
                    ForEach(WeekDays.allCases, id: \.self) { day in
                        if day != weekDay {
                            Button {
                                timelineWeek.getTimeline(day: day).copyItems(from: timelineWeek.getTimeline(day: weekDay))
                                timelineWeek.objectWillChange.send()
                            } label: {
                                Label("\(weekDayName(for: day))", systemImage: weekDayImage(for: day))
                            }
                        }
                    }
                } label: {
                    Label("Copy to Day", systemImage: "arrowshape.turn.up.forward")
                }
                
                Section {
                    Menu {
                        ForEach(savedKeys, id: \.self) { key in
                            Button {
                                withAnimation {
                                    timelineWeek.getTimeline(day: weekDay).copyItems(from: Timeline(key: key))
                                    timelineWeek.objectWillChange.send()
                                }
                            } label: {
                                Label(key, systemImage: textIcon(for: key))
                            }
                        }
                    } label: {
                        Label("Get Table", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                        saveTable = true
                    } label: {
                        Label("Save Table", systemImage: "square.and.arrow.down")
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        deleteAll = true
                    } label: {
                        Label("Clear Table", systemImage: "trash")
                    }
                }
                
                Section {
                    Button {
                        showingSettings = true
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}

struct TimeTableWeek_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableWeek(timelineWeek: TimelineWeek())
    }
}
