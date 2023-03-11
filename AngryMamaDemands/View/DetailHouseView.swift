//
//  DetailHouseView.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-09.
//

import SwiftUI
import PhotosUI

struct DetailHouseView: View {
    @Environment(\.dismiss) var dismiss
    
    var house: House
    
    @ObservedObject var viewModel = HouseViewModel()
    
    init(house: House) {
        self.house = house
    }
    
    private var titleOfThisView = "House"
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Member.lastName, ascending: true)],
        animation: .default)
    private var members: FetchedResults<Member>
    
    @State private var showAddMemberView = false
    
    @State private var photosPickerItem: PhotosPickerItem? = nil
    @State private var name: String = ""
    @MainActor @State private var isLoading = false
    @State private var photoData: Data? = nil
        
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("ex) Jane's safe house, My Hideout", text: $name)
                }
                
                Section(header: Text("Photo")) {
                    PhotosPicker(selection: $photosPickerItem, matching: .images) {
                        if let _ = photosPickerItem {
                            if isLoading {
                                ProgressView()
                                    .tint(.accentColor)
                            } else {
                                if let data = photoData, let imageSource = UIImage(data: data) {
                                    Image(uiImage: imageSource)
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            
                        } else {
                            HouseBlockView(name: name, viewModel: viewModel)
                        }
                    }
                    .onChange(of: photosPickerItem) { selectedPhoto in
                        Task {
                            isLoading = true
                            
                            if let selectedPhoto = selectedPhoto {
                                await updatePhoto(with: selectedPhoto)
                            }
                            
                            isLoading = false
                        }
                    }
                }
                
                Section {
                    Text("A Member")
                } header: {
                    HStack {
                        Text("Members")
                        Spacer()
                        Button {
                            showAddMemberView.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill").foregroundColor(.blue).font(.subheadline)
                        }

                    }
                }
                
                Section {
                    
                } header: {
                    Text("Demands")
                }
                
                Button("Save") {
                    dismiss()
                }
                .disabled(name.isEmpty)
                
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.red)
            }
            .navigationTitle(titleOfThisView)
        }
    }
    
    private func addHouse() {
        let shared = CoreDataStack.shared
        let context = shared.context
        
        let house = House(context: context)
        house.title = name
        
        shared.save()
    }
    
    private func updatePhoto(with selectedPhoto: PhotosPickerItem) async {
        photosPickerItem = selectedPhoto
        
        if let photoData = try? await selectedPhoto.loadTransferable(type: Data.self) {
            self.photoData = photoData
        }
    }
    
    struct DetailHouseView_Previews: PreviewProvider {
        static var previews: some View {
            let preview = CoreDataStack.preview
            let context = preview.context
            
            let house = House(context: context)
            house.title = "House"
            
            preview.save()
            
            return DetailHouseView(house: house)
        }
    }
}



