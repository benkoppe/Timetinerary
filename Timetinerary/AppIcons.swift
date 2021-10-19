//
//  AppIcons.swift
//  Timetinerary
//
//  Created by Ben K on 10/12/21.
//

import Foundation

let iconGroups = [defaults, tints, socials, pride]

let defaults = IconGroup(name: nil, icons: ["AppIcon"])

let tints = IconGroup(name: "Tints", icons: ["Wavy", "Snake", "Blood", "Royal", "Blossom"])

let socials = IconGroup(name: "Social", icons: ["Influencer", "Typing...", "Musical", "280 Characters", "Superspreader"])

let pride = IconGroup(name: "Pride", icons: ["Baker", "Helms"])

struct IconGroup: Hashable {
    let name: String?
    let icons: [String]
}
