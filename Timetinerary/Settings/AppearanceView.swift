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
            } footer: {
                PreviewView(bg: userColors.beforeBG, text: userColors.beforeText)
            }
            
            Section {
                UserColorPicker(title: "Background", type: .duringBG, color: $userColors.duringBG)
                UserColorPicker(title: "Foreground", type: .duringFG, color: $userColors.duringFG)
                UserColorPicker(title: "Text", type: .duringText, color: $userColors.duringText)
            } header: {
                Text("During Schedule")
            } footer: {
                PreviewView(bg: userColors.duringBG, fg: userColors.duringFG, text: userColors.duringText)
            }
            
            Section {
                UserColorPicker(title: "Background", type: .afterBG, color: $userColors.afterBG)
                UserColorPicker(title: "Text", type: .afterText, color: $userColors.afterText)
            } header: {
                Text("After Schedule")
            } footer: {
                PreviewView(bg: userColors.afterBG, text: userColors.afterText)
            }
            
            Section {
                UserColorPicker(title: "Background", type: .dayOffBG, color: $userColors.dayOffBG)
                UserColorPicker(title: "Foreground", type: .dayOffFG, color: $userColors.dayOffFG)
                UserColorPicker(title: "Text", type: .dayOffText, color: $userColors.dayOffText)
            } header: {
                Text("Days Off")
            } footer: {
                PreviewView(bg: userColors.dayOffBG, fg: userColors.dayOffFG, text: userColors.dayOffText)
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
    
    struct PreviewView: View {
        let bg: Color
        let fg: Color
        let text: Color
        
        init(bg: Color, fg: Color = .clear, text: Color) {
            self.bg = bg
            self.fg = fg
            self.text = text
        }
        
        var body: some View {
            HStack {
                Spacer()
                
                ZStack {
                    bg
                    
                    GeometryReader { geo in
                        fg.frame(width: geo.size.width * 0.5)
                    }
                    
                    Text("Preview")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(text)
                }
                .cornerRadius(20)
                .frame(width: 100, height: 100)
                
                Spacer()
            }
        }
    }
}

struct AppearanceView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceView()
    }
}
