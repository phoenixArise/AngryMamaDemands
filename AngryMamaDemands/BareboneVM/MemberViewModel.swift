//
//  MemberViewModel.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-10.
//

import Foundation
import _PhotosUI_SwiftUI

class MemberViewModel: ViewModel {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
   
    var isValidMember: Bool {
        guard firstName.isEmpty || lastName.isEmpty else { return false }
        return true
    }
    
    func addMember(to houseViewModel: HouseViewModel) {
        houseViewModel.addMember(self as MemberViewModel)
        print(houseViewModel.memberViewModels)
    }
}
