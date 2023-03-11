//
//  addHouseViewModel.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-10.
//

import Foundation
import Combine
import CoreData

class AddHouseViewModel: HouseViewModel {
        
    func addHouse(_ context: NSManagedObjectContext) {
        guard isValidHouse else { return }
        
        let house = House(context: context)
        house.title = name
        house.photo = photoData
        
        for memberViewModel in memberViewModels {
            let member = Member(context: context)
            member.firstName = memberViewModel.firstName
            member.lastName = memberViewModel.lastName
            member.house = house
        }
        
        for demandViewModel in demandViewModels {
            let demand = Demand(context: context)
            demand.name = demandViewModel.name
            demand.summary = demandViewModel.summary
            demand.house = house
        }       
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
