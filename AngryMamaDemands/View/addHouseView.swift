//
//  addHouseView.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-09.
//

import SwiftUI
import PhotosUI

struct addHouseView: View {
    private var titleOfThisView = "House"
    
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
                    Text("A Member")
                } header: {
                    HStack {
                        Text("Members")
                        Spacer()
                        Button {
                            print("Add a member")
                        } label: {
                            Image(systemName: "plus.circle.fill").foregroundColor(.blue).font(.subheadline)
                        }

                    }
                }
                
                Button("Save") {
                    print("Submit")
                }
                
                Button("Cancel") {
                    print("Submit")
                }
                .foregroundColor(.red)
            }
            .navigationTitle(titleOfThisView)
        }
    }
    
    private func updatePhoto(with selectedPhoto: PhotosPickerItem) async {
        photosPickerItem = selectedPhoto
        
        if let photoData = try? await selectedPhoto.loadTransferable(type: Data.self) {
            self.photoData = photoData
        }
    }
    
    struct addHouseView_Previews: PreviewProvider {
        static var previews: some View {
            addHouseView()
        }
    }
}
