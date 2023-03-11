//
//  DemandType.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-09.
//

import Foundation

enum DemandType {
    case routine(rule: Rule)
    case custom(dates: [Date])
}

enum Rule {
    case byDay(whatDays: [DayOfWeek])
    case byTurn
}


