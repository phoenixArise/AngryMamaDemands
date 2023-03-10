//
//  AddMemberView.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-09.
//

import SwiftUI

struct AddMemberView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName: String = ""
    @State private var lasttName: String = ""
    
    var house: House? = nil
    
    var member: Member {
        let shared = CoreDataStack.shared
        let context = shared.context
        
        let member = Member(context: context)
        member.firstName = ""
        member.lastName = ""
        
        return member
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lasttName)
                } header: {
                    Text("Name")
                }
                
                Section {
                    
                } header: {
                    Text("House")
                }
                
                Button("Save") {
                    saveMember()
                    dismiss()
                }
                
                Button("Cancel") {
                    rollBack()
                    dismiss()
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Member")
        }
    }
    
    private func rollBack() {
        let shared = CoreDataStack.shared
        shared.context.rollback()
    }
    
    private func saveMember() {
        let shared = CoreDataStack.shared
        member.firstName = firstName
        member.lastName = lasttName
        member.house = house
        shared.save()
    }
}

struct AddMemberView_Previews: PreviewProvider {
    static var previews: some View {
        let shared = CoreDataStack.preview
        let context = shared.context
        
        let house = House(context: context)
        house.title = "House"
        
        return AddMemberView(house: house)
    }
}
