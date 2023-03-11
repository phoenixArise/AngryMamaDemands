//
//  AddInstructionView.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-10.
//

import SwiftUI
import PhotosUI

struct AddInstructionView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var demandViewModel: DemandViewModel
    @ObservedObject var viewModel = AddInstructionViewModel()
    
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("ex) Wash your hands", text: $viewModel.explanation)
                } header: {
                    Text("Explain this step")
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
                            Image(systemName: "frying.pan.fill")
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
                }
                
                Section {
                    Button("Save") {
                        viewModel.addInstruction(to: demandViewModel)
                        print("Submit")
                        dismiss()
                    }
                    
                    Button("Cancel") {
                        print("Submit")
                        dismiss()
                    }
                    .foregroundColor(.red)
                } header: {
                    Text("Action")
                }
            }
            .navigationTitle("\(demandViewModel.name)")
        }
    }
}

struct AddInstructionView_Previews: PreviewProvider {
    static var previews: some View {
        let demandViewModel = DemandViewModel()
        demandViewModel.name = "Cook Dinner"
        return AddInstructionView(demandViewModel: demandViewModel)
    }
}



