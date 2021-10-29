//
//  ContentView.swift
//  Watch WatchKit Extension
//
//  Created by Ben K on 10/19/21.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @StateObject var connectivity = PhoneConnectivity()
    
    var body: some View {
        TimeView(timelineWeek: connectivity.timelineWeek)
            .environmentObject(connectivity.userColors)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
