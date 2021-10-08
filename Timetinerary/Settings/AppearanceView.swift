//
//  AppearanceView.swift
//  Timetinerary
//
//  Created by Ben K on 10/7/21.
//

import SwiftUI

struct AppearanceView: View {
    @EnvironmentObject var userColors: UserColors
    
    var body: some View {
        List {
            Section {
                UserColorPicker(title: "Background", type: .beforeBG, color: $userColors.beforeBG)
                UserColorPicker(title: "Text", type: .beforeText, color: $userColors.beforeText)
            } header: {
                Text("Before Schedule")
            }
            
            Section {
                UserColorPicker(title: "Background", type: .duringBG, color: $userColors.duringBG)
                UserColorPicker(title: "Foreground", type: .duringFG, color: $userColors.duringFG)
                UserColorPicker(title: "Text", type: .duringText, color: $userColors.duringText)
            } header: {
                Text("During Schedule")
            }
            
            Section {
                UserColorPicker(title: "Background", type: .afterBG, color: $userColors.afterBG)
                UserColorPicker(title: "Text", type: .afterText, color: $userColors.afterText)
            } header: {
                Text("After Schedule")
            }
            
            Section {
                UserColorPicker(title: "Background", type: .dayOffBG, color: $userColors.dayOffBG)
                UserColorPicker(title: "Foreground", type: .dayOffFG, color: $userColors.dayOffFG)
                UserColorPicker(title: "Text", type: .dayOffText, color: $userColors.dayOffText)
            } header: {
                Text("Days Off")
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    struct UserColorPicker: View {
        let title: String
        let type: UserColorTypes
        @Binding var color: Color
        
        var body: some View {
            HStack {
                Text(title)
                
                Spacer()
                
                Button("Reset") {
                    color = Color(type.assetText)
                }
                .padding(.horizontal)
                .buttonStyle(.plain)
                .foregroundColor(.blue)
                
                ColorPicker(title, selection: $color)
                    .labelsHidden()
            }
        }
    }
}

struct AppearanceView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceView()
    }
}
