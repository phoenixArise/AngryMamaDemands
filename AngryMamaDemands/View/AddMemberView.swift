//
//  AddMemberView.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-09.
//

import SwiftUI

struct AddMemberView: View {
    @State private var firstName: String = ""
    @State private var lasttName: String = ""
    
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
                    print("Submit")
                }
                
                Button("Cancel") {
                    print("Submit")
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Member")
        }
    }
}

struct AddMemberView_Previews: PreviewProvider {
    static var previews: some View {
        AddMemberView()
    }
}
