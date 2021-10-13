//
//  AppIconsView.swift
//  Timetinerary
//
//  Created by Ben K on 10/12/21.
//

import SwiftUI

struct AppIconsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("icon", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var currentIcon: String = "AppIcon"
    
    var body: some View {
        List {
            ForEach(iconGroups, id: \.self) { group in
                Section {
                    ForEach(group.icons, id: \.self) { iconName in
                        IconItemView(iconName: iconName, currentIcon: $currentIcon)
                    }
                } header: {
                    if let name = group.name { Text(name) }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("App Icon")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    struct IconItemView: View {
        let iconName: String
        @Binding var currentIcon: String
        
        var body: some View {
            Button(action: {
                UIApplication.shared.setAlternateIconName(iconName == "AppIcon" ? nil : iconName.replacingOccurrences(of: " ", with: ""), completionHandler: { error in
                    if let error = error {
                        print(error)
                    } else {
                        currentIcon = iconName
                    }
                })
            }) {
                HStack {
                    Image(iconName + "Icon")
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                    Text(iconName == "AppIcon" ? "Default" : iconName)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if iconName == currentIcon {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
            }
            .buttonStyle(.borderless)
        }
    }
}

struct AppIconsView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconsView()
    }
}
