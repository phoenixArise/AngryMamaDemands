//
//  Constant.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-08.
//

import Foundation
import SwiftUI

struct Constant {
    static let containerName = "AngryMamaDemands"
    static let unit = 125.0
}

enum DayOfWeek: Int, CaseIterable, Hashable, Identifiable {
    var id: Int {
        self.rawValue
    }
    
    
    static let Labels = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
    
    func label() -> String {
        let index = self.rawValue
        return DayOfWeek.Labels[index]
    }
    
    func color() -> Color {
        switch self {
        case .Sunday:
            return .red
        default:
            return .primary
        }
    }
}
