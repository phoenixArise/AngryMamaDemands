//
//  DetailHouseView.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-09.
//

import SwiftUI
import PhotosUI
import CoreData

struct DetailHouseView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    var house: House
    
    @ObservedObject var viewModel = HouseViewModel()
    
    init(house: House) {
        self.house = house
        self.demandFetchRequest = {
            FetchRequest(
                entity: Demand.entity(),
                sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
                predicate: NSPredicate(format: "%K == %@", "house.title", house.title!)
            )
        }()
        
        self.memberFetchRequest = {
            FetchRequest(entity: Member.entity(),
                         sortDescriptors: [NSSortDescriptor(key: "firstName", ascending: true)],
                         predicate: NSPredicate(format: "%K == %@", "house.title", house.title!)
            )
        }()
    }
    
    
    private var titleOfThisView = "House"
    
    let memberFetchRequest: FetchRequest<Member>
    private var members: FetchedResults<Member> {
        memberFetchRequest.wrappedValue
    }
    
    var demandFetchRequest: FetchRequest<Demand>
    private var demands: FetchedResults<Demand> {
        demandFetchRequest.wrappedValue
    }
    
    @State private var showAddMemberView = false
    @State private var showAddDemandView = false
    
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
                    List{
                        ForEach(members) { member in
                            Text("\(member.firstName ?? "") \(member.lastName ?? "")")
                        }
                        .onDelete { offsets in
                            viewModel.memberViewModels.remove(atOffsets: offsets)
                        }
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
                
                Section {
                    List{
                        ForEach(demands) { demand in
                            Text("\(demand.name ?? "")")
                        }
                        .onDelete { offsets in
                            viewModel.demandViewModels.remove(atOffsets: offsets)
                        }
                    }
                } header: {
                    HStack {
                        Text("Demands")
                        Spacer()
                        Button {
                            showAddDemandView.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill").foregroundColor(.blue).font(.subheadline)
                        }
                    }
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
            .sheet(isPresented: $showAddDemandView, content: {
                AddDemandView(houseViewModel: viewModel)
            })
            .sheet(isPresented: $showAddMemberView, content: {
                AddMemberView(houseViewModel: viewModel)
            })
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
            
            let member = Member(context: context)
            member.firstName = "Member"
            member.lastName = "First"
            member.house = house
            
            let demand = Demand(context: context)
            demand.name = "Demand"
            member.house = house
            
            preview.save()
            
            return DetailHouseView(house: house)
        }
    }
}



