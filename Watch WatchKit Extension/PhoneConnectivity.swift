//
//  PhoneConnectivity.swift
//  Watch WatchKit Extension
//
//  Created by Ben K on 10/19/21.
//

import Foundation
import Combine
import WatchConnectivity

class PhoneConnectivity: ObservableObject {
    var session: WCSession
    let delegate: PhoneConnectivityDelegate
    
    let week = PassthroughSubject<TimelineWeek, Never>()
    let colors = PassthroughSubject<UserColors, Never>()
    
    @Published private(set) var timelineWeek: TimelineWeek = TimelineWeek()
    @Published private(set) var userColors: UserColors = UserColors()
    
    init(session: WCSession = .default) {
        self.delegate = PhoneConnectivityDelegate(week: week, colors: colors)
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()
        
        week
            .receive(on: DispatchQueue.main)
            .assign(to: &$timelineWeek)
        
        colors
            .receive(on: DispatchQueue.main)
            .assign(to: &$userColors)
    }
}

class PhoneConnectivityDelegate: NSObject, WCSessionDelegate {
    let week: PassthroughSubject<TimelineWeek, Never>
    let colors: PassthroughSubject<UserColors, Never>
    
    init(week: PassthroughSubject<TimelineWeek, Never>, colors: PassthroughSubject<UserColors, Never>) {
        self.week = week
        self.colors = colors
        super.init()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            print("received")
            
            let decoder = JSONDecoder()
            var week = TimelineWeek()
            var colors = UserColors()
            
            if let weekData = applicationContext["week"] as? Data, let decodedWeek = try? decoder.decode(TimelineWeek.self, from: weekData) {
                week = decodedWeek
            }
            if let colorData = applicationContext["colors"] as? Data, let decodedColors = try? decoder.decode(UserColors.self, from: colorData) {
                colors = decodedColors
            }
            
            week.saveAll()
            colors.save()
            
            self.week.send(week)
            self.colors.send(colors)
        }
    }
}
