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
    
    private var titleOfThisView = "House"
    
    @State private var house: House
       
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
                            HouseBlockView(name: name)
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
                    List(members, id: \.id) { member in
                        Text("\(member.firstName ?? "") \(member.firstName ?? "")")
                    }
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
                
                Button("Save") {
                    saveHouse()
                    dismiss()
                }
                .disabled(name.isEmpty)
                
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.red)
            }
            .sheet(isPresented: $showAddMemberView, content: {
                if let house = house {
                    AddMemberView(house: house)
                } else {
                    Text("House Not Found")
                }
            })
            .navigationTitle(titleOfThisView)
        }
    }
    
    private func saveHouse() {
        let shared = CoreDataStack.shared
        shared.save()
    }
    
    private func updatePhoto(with selectedPhoto: PhotosPickerItem) async {
        photosPickerItem = selectedPhoto
        
        if let photoData = try? await selectedPhoto.loadTransferable(type: Data.self) {
            self.photoData = photoData
        }
    }
    
    struct addHouseView_Previews: PreviewProvider {
        static var previews: some View {
            AddHouseView()
        }
    }
}
