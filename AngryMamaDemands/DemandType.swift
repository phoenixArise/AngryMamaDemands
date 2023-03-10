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
    case byDay(whatDays: [Day])
    case byTurn
}

enum Day: String {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
}
