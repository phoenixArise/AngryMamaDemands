//
//  ContentView.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-07.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \House.title, ascending: true)],
        animation: .default)
    private var houses: FetchedResults<House>
    
    @State private var showAddHouseView = false
   
    
    var body: some View {
        NavigationView {
            List {
                ForEach(houses) { house in
                    NavigationLink {
                        DetailHouseView(house: house)
                    } label: {
                        Text("\(house.title!)")
                    }
                }
                .onDelete(perform: deleteHouses)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        showAddHouseView.toggle()
                    } label: {
                        Label("Add House", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddHouseView) {
                AddHouseView()
            }
            Text("Select an item")
        }
    }

    private func deleteHouses(offsets: IndexSet) {
        withAnimation {
            offsets.map { houses[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, CoreDataStack.preview.context)
    }
}
