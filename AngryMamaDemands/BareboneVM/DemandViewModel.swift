//
//  DemandViewModel.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-10.
//

import Foundation
import SwiftUI

class DemandViewModel: ViewModel {
    @Environment(\.calendar) var calendar
    
    @Published var name = ""
    @Published var summary = ""
    @Published var isRoutine = false
    @Published var customDates: Set<DateComponents> = []
    @Published var regularDays: Set<DayOfWeek> = []
    @Published var instructionViewModels: [InstructionViewModel] = []
    
    func addDemand(to houseViewModel: HouseViewModel) {
        houseViewModel.addDemand(self as DemandViewModel)
    }
    
    func addInstruction(_ instructionViewModel: InstructionViewModel) {
        instructionViewModels.append(instructionViewModel)
    }
}
