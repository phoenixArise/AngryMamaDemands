//
//  AddMemberView.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-09.
//

import SwiftUI
import PhotosUI

struct AddMemberView: View {
    @Environment(\.dismiss) var dismiss
    
    var houseViewModel: HouseViewModel
    @ObservedObject var viewModel: AddMemberViewModel = AddMemberViewModel()
    
    @State private var photosPickerItem: PhotosPickerItem? = nil
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("First Name", text: $viewModel.firstName)
                    TextField("Last Name", text: $viewModel.lastName)
                } header: {
                    Text("Name")
                }
                
                Section {
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
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 125.0)
                                .foregroundColor(.random())
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
                } header: {
                    Text("Photo (Optional)")
                }
                
                Button("Save") {
                    viewModel.addMember(to: houseViewModel)
                    dismiss()
                }
                .disabled(viewModel.isValidMember)
                
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Member")
        }
    }
}

struct AddMemberView_Previews: PreviewProvider {
    static var previews: some View {
        let houseViewModel = AddHouseViewModel()
        
        return AddMemberView(houseViewModel: houseViewModel)
    }
}
