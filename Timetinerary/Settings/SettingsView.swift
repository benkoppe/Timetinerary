//
//  SettingsView.swift
//  Timetinerary
//
//  Created by Ben K on 10/6/21.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                SettingsItem(name: "Preferences", systemImage: "gear", background: .gray) {
                    PreferencesView()
                }
                
                SettingsItem(name: "Appearance", systemImage: "paintpalette", background: .red) {
                    AppearanceView()
                }
                
                Section {
                    SettingsItem(name: "Saved Tables", systemImage: "square.and.arrow.down", background: .blue) {
                        SavedTablesView()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    struct SettingsItem<Content: View>: View {
        let name: String
        let image: Image
        let foreground: Color
        let background: Color
        
        let destination: Content
        
        init(name: String, systemImage: String, foreground: Color = .primary, background: Color, @ViewBuilder content: () -> Content) {
            self.name = name
            self.image = Image(systemName: systemImage)
            self.foreground = foreground
            self.background = background
            
            self.destination = content()
        }
        
        var body: some View {
            NavigationLink(destination: destination) {
                HStack {
                    image
                        .frame(width: 30, height: 30)
                        .foregroundColor(foreground)
                        .background(background)
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                        .padding(.trailing, 5)
                    Text(name)
                    /*Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.tertiaryLabel)*/
                }
                .foregroundColor(.primary)
                .padding(.vertical, 5)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
