//
//  addDemandView.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-09.
//

import SwiftUI

struct AddDemandView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var houseViewModel: HouseViewModel
    @ObservedObject var viewModel = AddDemandViewModel()
    
    @State private var selectedDemandType: Int = 0
    @State private var selectedDays = Set<DateComponents>()
    
    @State private var showAddInstruction = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("ex) Wash Dishes, Cook Dinner", text: $viewModel.name)
                } header: {
                    Text("Name")
                }
                
                Section {
                    TextField("Optional", text: $viewModel.summary)
                } header: {
                    Text("Summary")
                }
                
                Section {
                    List {
                        ForEach(viewModel.instructionViewModels) { instructionViewModel in
                            Text(instructionViewModel.explanation)
                        }
                        .onDelete { self.viewModel.instructionViewModels.remove(atOffsets: $0) }
                        .onMove { self.viewModel.instructionViewModels.move(fromOffsets: $0, toOffset: $1) }
                    }
                } header: {
                    SectionHeaderWithAddButton("Instructions", $showAddInstruction)
                }
                
                Section {
                    Picker(selection: $selectedDemandType, label: Text("Demand Type")) {
                        Text("Regulary").tag(0)
                        Text("Custom").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    if selectedDemandType == 0 {
                        WeekDayPicker(viewModel: viewModel)
                    } else {
                        MultiDatePicker("Pick Dates", selection: $viewModel.customDates)
                    }
                    
                } header: {
                    Text("SCHEDULE")
                }
                
                Button("Save") {
                    viewModel.addDemand(to: houseViewModel)
                    dismiss()
                }
                
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.red)
            }
            .sheet(isPresented: $showAddInstruction, content: {
                AddInstructionView(demandViewModel: viewModel)
            })
            .navigationTitle("Demand")
        }
    }
}


struct WeekDayPicker: View {
    
    @ObservedObject var viewModel: DemandViewModel
    
    var body: some View {
        HStack {
            ForEach(DayOfWeek.allCases) { day in
                DayView(day: day)
                    .onTapGesture {
                        if viewModel.regularDays.contains(day) {
                            viewModel.regularDays.remove(day)
                        } else {
                            viewModel.regularDays.insert(day)
                        }
                    }
            }
        }
    }
}

struct DayView: View {
    let day: DayOfWeek
    
    @State var isSelected = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(
                LinearGradient(
                    gradient: .init(
                        colors: [.pink, .purple]
                    ),
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .opacity(isSelected ? 1.0 : 0.5)
            )
            .overlay(
                Text(day.label())
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.01)
            )
            .onTapGesture {
                isSelected.toggle()
            }
    }
}

struct addDemandView_Previews: PreviewProvider {
    static var previews: some View {
        let houseVM = HouseViewModel(inMemory: true)
        AddDemandView(houseViewModel: houseVM)
    }
}

// MARK: - SUBVIEWS
extension AddDemandView {
    private func SectionHeaderWithAddButton(_ headerTitle: String, _ show: Binding<Bool>) -> some View {
        return HStack {
            Text(headerTitle)
            Spacer()
            Button {
                show.wrappedValue.toggle()
            } label: {
                Image(systemName: "plus.circle.fill").foregroundColor(.blue).font(.subheadline)
            }
        }
    }
}

