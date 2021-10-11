//
//  HasChanged.swift
//  Timetinerary
//
//  Created by Ben K on 10/11/21.
//

import Foundation

func hasChanged() {
    NotificationCenter.default.post(name: Notification.Name("hasChanged"), object: nil)
}
