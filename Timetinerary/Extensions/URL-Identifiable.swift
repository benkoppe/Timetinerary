//
//  URL-Identifiable.swift
//  Timetinerary
//
//  Created by Ben K on 10/14/21.
//

import Foundation

extension URL: Identifiable {
    public var id: UUID {
        UUID()
    }
}
