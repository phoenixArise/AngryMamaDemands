//
//  addHouseView.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-09.
//

import SwiftUI
import PhotosUI
import Combine

struct AddHouseView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject private var viewModel: AddHouseViewModel = AddHouseViewModel()
    
    @State var showAddMemberView = false
    @State var showAddDemandView = false
    @State private var photosPickerItem: PhotosPickerItem? = nil
    @MainActor @State private var isLoading = false
       
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("ex) Jane's safe house, My Hideout", text: $viewModel.name)
                }
                
                Section(header: Text("Photo")) {
                    PhotosPicker(selection: $photosPickerItem, matching: .images) {
                        if let _ = photosPickerItem {
                            if isLoading {
                                ProgressView()
                                    .tint(.accentColor)
                            } else {
                                if let data = viewModel.photoData, let imageSource = UIImage(data: data) {
                                    Image(uiImage: imageSource)
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            
                        } else {
                            HouseBlockView(name: viewModel.name, viewModel: viewModel)
                        }
                    }
                    .onChange(of: photosPickerItem) { selectedPhoto in
                        Task {
                            isLoading = true
                            
                            if let selectedPhoto = selectedPhoto {
                                await viewModel.updatePhoto(with: selectedPhoto)
                            }
                            
                            isLoading = false
                        }
                    }
                }
                
                Section {
                    List {
                        ForEach(viewModel.memberViewModels) { memberViewModel in
                            Text("\(memberViewModel.firstName) \(memberViewModel.lastName)")
                        }
                        .onDelete { self.viewModel.memberViewModels.remove(atOffsets: $0) }
                        .onMove { self.viewModel.memberViewModels.move(fromOffsets: $0, toOffset: $1) }
                    }
                } header: {
                    SectionHeaderWithAddButton("Members", $showAddMemberView)
                }
                
                Section {
                    List {
                        ForEach(viewModel.demandViewModels) { demandViewModel in
                            Text(demandViewModel.name)
                        }
                        .onDelete { self.viewModel.demandViewModels.remove(atOffsets: $0) }
                        .onMove { self.viewModel.demandViewModels.move(fromOffsets: $0, toOffset: $1) }
                    }
                } header: {
                    SectionHeaderWithAddButton("Demands", $showAddDemandView)
                }
                
                Section {
                    Button("Save") {
                        saveHouse()
                        dismiss()
                    }
                    .disabled(!viewModel.isValidHouse)
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                } header: {
                    Text("Action")
                }
            }
            .sheet(isPresented: $showAddDemandView, content: {
                AddDemandView(houseViewModel: viewModel)
            })
            .sheet(isPresented: $showAddMemberView, content: {
                AddMemberView(houseViewModel: viewModel)
            })
            .navigationTitle("House")
        }
    }
    
    private func saveHouse() {
        let shared = CoreDataStack.shared
        shared.save()
    }
    
    
    
    struct addHouseView_Previews: PreviewProvider {
        static var previews: some View {
            AddHouseView()
        }
    }
}

// MARK: - SUBVIEWS
extension AddHouseView {
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
