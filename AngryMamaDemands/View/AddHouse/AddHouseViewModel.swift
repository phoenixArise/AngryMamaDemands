//
//  addHouseViewModel.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-10.
//

import Foundation
import Combine
import CoreData
import _PhotosUI_SwiftUI

class AddHouseViewModel: HouseViewModel {
        
    func addHouse() {
        guard isValidHouse else { return }
        
        let house = House(context: coreDataStack.context)
        house.title = name
        house.photo = photoData
    }
    
    func saveHouse() {
        coreDataStack.save()
    }
    
    
    
}
