//
//  TextIcon.swift
//  Timetinerary
//
//  Created by Ben K on 10/7/21.
//

import Foundation

func textIcon(for text: String) -> String {
    if let char = text.trimmingCharacters(in: .whitespaces).first?.lowercased() {
        return "\(char).square"
    } else {
        return ""
    }
}
