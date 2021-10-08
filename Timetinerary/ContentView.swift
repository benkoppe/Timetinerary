//
//  ContentView.swift
//  Timetinerary
//
//  Created by Ben K on 10/5/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userColors: UserColors = UserColors()
    
    var body: some View {
        TimeTableWeek()
            .environmentObject(userColors)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
