//
//  HouseViewModel.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-10.
//

import Foundation
import CoreData
import Combine
import _PhotosUI_SwiftUI
import SwiftUI

class HouseViewModel: ViewModel {
    @Published var name: String = ""
    
    @Published var memberViewModels: [MemberViewModel] = []
    @Published var demandViewModels: [DemandViewModel] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    let coreDataStack: CoreDataStack
        
    init(inMemory: Bool = false) {
        switch inMemory {
        case true:
            coreDataStack = CoreDataStack.preview
        case false:
            coreDataStack = CoreDataStack.shared
        }
    }
    
    var isValidHouse: Bool {
        guard !name.isEmpty else { return false }
        return true
    }
    
    func addMember(_ memberViewModel: MemberViewModel) {
        memberViewModels.append(memberViewModel)
    }
    
    func addDemand(_ demandViewModel: DemandViewModel) {
        demandViewModels.append(demandViewModel)
    }
    
    var colors: [Color] = {
        AnyIterator { } .prefix(2).map {
            .random(saturation: 2 / 3, value: 0.85)
        }
    }()
}
