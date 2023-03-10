//
//  addDemandView.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-09.
//

import SwiftUI

struct AddDemandView: View {
    @Environment(\.calendar) var calendar
    
    @State private var name = ""
    @State private var summary = ""
    @State private var isRoutine = false
    @State private var dates: Set<DateComponents> = []
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("ex) Wash Dishes, Cook Dinner", text: $name)
                } header: {
                    Text("Name")
                }
                
                Section {
                    TextField("Optional", text: $summary)
                } header: {
                    Text("Summary")
                }
                
                Section {
                    List {
                        Text("1. Check whether indoor garbage bins are full or not. Empty 'em out if they are")
                        Text("2. Take the garbage bins and recycle bins out to the curbside between past 8 PM (the night before) and before 7 AM in the morning")
                        Text("3. Ensure that there is some gap about two ft. between the bins")
                    }
                } header: {
                    Text("Instructions")
                }
                
                Section {
                    Toggle("Is this task a Routine?", isOn: $isRoutine)
                        .toggleStyle(CheckboxToggleStyle())
                    
                    if isRoutine {
                        Text("It's a routine for now")
                    } else {
                        MultiDatePicker(selection: $dates) {
                            Text("Pick dates")
                        }
                        
                        List {
                            ForEach(Array(dates), id: \.self) { date in
                                Text(calendar.date(from: date)?.formatted(date: .long, time: .omitted) ?? "")
                            }
                        }
                    }
                    
                } header: {
                    Text("Routine")
                }
                
                Button("Save") {
                    print("Submit")
                }
                
                Button("Cancel") {
                    print("Submit")
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Demand")
        }
    }
    
    struct CheckboxToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            // 1
            Button(action: {
                
                // 2
                configuration.isOn.toggle()
                
            }, label: {
                HStack {
                    // 3
                    Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    
                    configuration.label.foregroundColor(.black)
                }
            })
        }
    }
    
    private var datesDescription: [String] {
        var result = [String]()
        for date in dates {
            result.append(date.description)
        }
        return result
    }
    
}

struct addDemandView_Previews: PreviewProvider {
    static var previews: some View {
        AddDemandView()
    }
}

