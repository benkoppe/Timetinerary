//
//  BoardingView.swift
//  Timetinerary
//
//  Created by Ben K on 10/9/21.
//

import SwiftUI

struct BoardingView: View {
    @State private var tab = 0
    @State private var isLastItem = false
    
    var body: some View {
        ZStack {
            TabView(selection: $tab) {
                WelcomeView(tab: $tab)
                    .tag(0)
                WidgetView(tab: $tab)
                    .tag(1)
                NotificationsView(tab: $tab)
                    .tag(2)
                AppearanceView()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: tab) { value in
                withAnimation {
                    if value >= 1 {
                        isLastItem = true
                    } else {
                        isLastItem = false
                    }
                }
            }
            .interactiveDismissDisabled()
        }
    }
    
    struct WelcomeView: View {
        @Binding var tab: Int
        
        var body: some View {
            VStack {
                Spacer()
                
                VStack {
                    Text("Welcome to")
                        .font(.system(size: 40))
                    Text("Timetinerary")
                        .font(.system(size: 50))
                        .bold()
                    Image("Schedule")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .frame(width: 325)
                        .shadow(radius: 20)
                    Text("Create timeline schedules in seconds.")
                        .foregroundColor(.secondary)
                        .italic()
                        .padding()
                }
                .padding(.vertical)
                
                Spacer()
                Button {
                    withAnimation { tab = 1 }
                } label: {
                    HStack {
                        Spacer()
                        Text("See More")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding(20)
                .padding(.horizontal)
            }
        }
    }
    
    struct WidgetView: View {
        @Binding var tab: Int
        
        var body: some View {
            VStack {
                Spacer()
                
                VStack {
                    Text("Widget")
                        .font(.system(size: 40))
                    Image("Widget")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .cornerRadius(20)
                        .shadow(radius: 30)
                        .padding(.bottom, 10)
                    Text("Add your timeline to the homescreen as a widget!")
                        .foregroundColor(.secondary)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding(.vertical)
                
                Spacer()
                Button {
                    withAnimation { tab = 2 }
                } label: {
                    HStack {
                        Spacer()
                        Text("Next")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding(20)
                .padding(.horizontal)
            }
        }
    }
    
    struct NotificationsView: View {
        @Binding var tab: Int
        
        var body: some View {
            VStack {
                Spacer()
                
                VStack {
                    Text("Notifications")
                        .font(.system(size: 40))
                    Image("Notifications")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .cornerRadius(10)
                        .shadow(radius: 30)
                        .padding(.bottom, 10)
                    Text("Set up notifications in the settings screen!")
                        .foregroundColor(.secondary)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding(.vertical)
                
                Spacer()
                Button {
                    withAnimation { tab = 3 }
                } label: {
                    HStack {
                        Spacer()
                        Text("Next")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding(20)
                .padding(.horizontal)
            }
        }
    }
    
    struct AppearanceView: View {
        @Environment(\.dismiss) var dismiss
        
        var body: some View {
            VStack {
                Spacer()
                
                VStack {
                    Text("Customizable")
                        .font(.system(size: 40))
                    Image("Appearance")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .cornerRadius(20)
                        .shadow(radius: 30)
                        .padding(.bottom, 10)
                    Text("Fully customizable - select the colors you want!")
                        .foregroundColor(.secondary)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding(.vertical)
                
                Spacer()
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Get Started")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding(20)
                .padding(.horizontal)
            }
        }
    }
}

struct BoardingView_Previews: PreviewProvider {
    static var previews: some View {
        BoardingView()
        BoardingView()
            .preferredColorScheme(.dark)
        BoardingView()
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
