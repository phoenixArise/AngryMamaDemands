//
//  Instruction.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-10.
//

import Foundation

class InstructionViewModel: ViewModel {
    @Published var explanation: String = ""
    
    func addInstruction(to demandViewModel: DemandViewModel) {
        demandViewModel.addInstruction(self)
    }
}
