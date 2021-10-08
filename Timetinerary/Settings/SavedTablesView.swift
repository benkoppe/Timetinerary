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
    
    var body: some View {
        Group {
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
        .confirmationDialog("Are you sure you want to clear you saved tables??", isPresented: $deleteAll) {
            Button("Clear All", role: .destructive) {
                for key in savedKeys {
                    let defaults = UserDefaults.init(suiteName: "group.com.benk.timetinerary")
                    defaults?.removeObject(forKey: key)
                    withAnimation { savedKeys = [] }
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
    
    struct KeyItem: View {
        @Binding var savedKeys: [String]
        let key: String
        
        var body: some View {
            HStack {
                Text(key)
                Spacer()
                Image(systemName: textIcon(for: key))
            }
        }
    }
}

struct SavedTablesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedTablesView()
    }
}
