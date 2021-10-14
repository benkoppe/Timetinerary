//
//  TimetineraryApp.swift
//  Timetinerary
//
//  Created by Ben K on 10/5/21.
//

import SwiftUI

@main
struct TimetineraryApp: App {
    @AppStorage("showLanding", store: UserDefaults(suiteName: "group.com.benk.timetinerary")) var showLanding: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .sheet(isPresented: $showLanding) {
                    BoardingView()
                }
                .onOpenURL { url in
                    if url.isFileURL {
                        Template.importURL(from: url)
                    }
                }
        }
    }
}
