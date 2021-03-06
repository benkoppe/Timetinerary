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
                
                Section {
                    SettingsItem(name: "Appearance", systemImage: "paintpalette", background: .red) {
                        AppearanceView()
                    }
                    
                    SettingsItem(name: "App Icon", systemImage: "clock", background: Color("Icon")) {
                        AppIconsView()
                    }
                    
                    SettingsItem(name: "Saved Tables", systemImage: "square.and.arrow.down", background: .blue) {
                        SavedTablesView()
                    }
                } header: {
                    Text("Preferences")
                }
                
                Section {
                    SettingsItem(name: "Notifications", systemImage: "app.badge", background: .pink) {
                        NotificationsView()
                    }
                }
                
                Section {
                    SettingsItem(name: "About", systemImage: "info.circle", background: .indigo) {
                        AboutView()
                    }
                    SettingsItem(name: "Contact", systemImage: "at", background: .green) {
                        ContactView()
                    }
                    SettingsItem(name: "Licenses", systemImage: "text.justifyleft", background: Color("Brown")) {
                        LicensesView()
                    }
                } header: {
                    Text("About")
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
        
        init(name: String, systemImage: String, foreground: Color = .white, background: Color, @ViewBuilder content: () -> Content) {
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
