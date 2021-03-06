//
//  SavedTablesView.swift
//  Timetinerary
//
//  Created by Ben K on 10/6/21.
//

import SwiftUI

struct SavedTablesView: View {
    @AppStorage("defaultSaved", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var savedKeys: [String] = []
    
    @State private var deleteAll = false
    
    @State private var templateAlert = false
    
    var body: some View {
        ZStack {
            if !savedKeys.isEmpty {
                List {
                    ForEach(savedKeys, id: \.self) { key in
                        KeyItem(savedKeys: $savedKeys, key: key)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
            } else {
                VStack(spacing: 10) {
                    Spacer()
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 40))
                    Text("Saved Time Tables")
                        .font(.title)
                    Text("Save your time tables to access them at any time later!")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Saved Tables")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                EditButton()
                    .disabled(savedKeys.isEmpty)
                
                Button(role: .destructive) {
                    deleteAll = true
                } label: {
                    Image(systemName: "trash")
                }
                .disabled(savedKeys.isEmpty)
                .tint(.red)
            }
        }
        .sheet(isPresented: $templateAlert) {
            TemplateView(getTable: getTable(result:))
        }
        .confirmationDialog("Are you sure you want to clear you saved tables??", isPresented: $deleteAll) {
            Button("Clear All", role: .destructive) {
                for key in savedKeys {
                    let defaults = UserDefaults.init(suiteName: "group.com.benk.timetinerary")
                    defaults?.removeObject(forKey: key)
                    withAnimation { savedKeys = [] }
                }
            }
        }
        .onShake {
            templateAlert = true
        }
    }
    
    func getTable(result: String?) {
        if let result = result {
            if let template = templates.first(where: { $0.name == result.lowercased() }) {
                for timeline in template.timelines {
                    if !savedKeys.contains(timeline.key) {
                        let newTimeline = Timeline(key: timeline.key)
                        newTimeline.timelineItems = TimelineItem.getTimelineItems(from: timeline.data) ?? []
                        savedKeys.append(timeline.key)
                    }
                }
            } else if !result.isEmpty {
                let data = Data(result.utf8)
                let key = UUID().uuidString
                let newTimeline = Timeline(key: key)
                newTimeline.timelineItems = TimelineItem.getTimelineItems(from: data) ?? []
                if newTimeline.timelineItems.count > 0 {
                    savedKeys.append(key)
                    newTimeline.save()
                } else {
                    let defaults = UserDefaults.init(suiteName: "group.com.benk.timetinerary")
                    defaults?.removeObject(forKey: key)
                }
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        savedKeys.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let key = savedKeys[offset]
            let defaults = UserDefaults.init(suiteName: "group.com.benk.timetinerary")
            defaults?.removeObject(forKey: key)
            let _ = withAnimation { savedKeys.remove(at: offset) }
        }
    }
    
    struct TemplateView: View {
        @Environment(\.dismiss) var dismiss
        
        @State private var text = ""
        let getTable: (String) -> Void
        
        var body: some View {
            NavigationView {
                VStack(spacing: 10) {
                    TextField("Template Code/Data", text: $text)
                        .textFieldStyle(.roundedBorder)
                    Spacer()
                }
                .padding()
                .navigationTitle("Import Template")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            getTable(text)
                            dismiss()
                        }
                        .disabled(text.isEmpty)
                    }
                }
            }
        }
    }
    
    struct KeyItem: View {
        @Binding var savedKeys: [String]
        let key: String
        
        @State private var editKey = ""
        @State private var shouldRename = false
        @FocusState private var isRenaming: Bool
        
        var body: some View {
            HStack {
                TextField("Name", text: $editKey)
                    .submitLabel(.send)
                    .onSubmit {
                        renameTable(result: editKey)
                    }
                    .submitScope(false)
                    .disabled(!shouldRename)
                    .focused($isRenaming)
                    .onChange(of: shouldRename) { newValue in
                        if newValue {
                            isRenaming = true
                        }
                    }
                    .onChange(of: isRenaming) { newValue in
                        if !newValue {
                            shouldRename = false
                        }
                    }
                Spacer()
                Image(systemName: textIcon(for: key))
            }
            .contextMenu {
                Button {
                    shouldRename = true
                } label: {
                    Text("Rename")
                    Image(systemName: "pencil")
                }
                Button {
                    let data = Timeline(key: key).getDataSingular()
                    UIPasteboard.general.setValue(String(decoding: data, as: UTF8.self), forPasteboardType: "public.plain-text")
                } label: {
                    Text("Copy Data")
                    Image(systemName: "doc.on.doc")
                }
            }
            .onAppear {
                editKey = key
            }
            
        }
        
        func renameTable(result: String) {
            if !result.isEmpty, !savedKeys.contains(result) {
                let oldTimeline = Timeline(key: key)
                let newTimeline = Timeline(key: result)
                newTimeline.copyItems(from: oldTimeline)
                newTimeline.save()
                
                let defaults = UserDefaults.init(suiteName: "group.com.benk.timetinerary")
                defaults?.removeObject(forKey: key)
                
                savedKeys.append(result)
                savedKeys.removeAll(where: { $0 == key })
            }
        }
    }
}

struct SavedTablesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedTablesView()
    }
}
