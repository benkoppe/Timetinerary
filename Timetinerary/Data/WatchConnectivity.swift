//
//  WatchConnectivity.swift
//  Timetinerary
//
//  Created by Ben K on 10/19/21.
//

import Foundation
import WatchConnectivity

class WatchConnectivity {
    var session: WCSession
    let delegate: WatchConnectivityDelegate
    
    init(session: WCSession = .default) {
        self.delegate = WatchConnectivityDelegate()
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()
    }
    
    func sendChanges(week: TimelineWeek, colors: UserColors) {
        let encoder = JSONEncoder()
        
        if let weekData = try? encoder.encode(week), let colorData = try? encoder.encode(colors) {
            var applicationContext: [String : Any] = [:]
            
            applicationContext["week"] = weekData
            applicationContext["colors"] = colorData
            
            try? session.updateApplicationContext(applicationContext)
        }
    }
}

class WatchConnectivityDelegate: NSObject, WCSessionDelegate {
    init(session: WCSession = .default) {
        super.init()
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
