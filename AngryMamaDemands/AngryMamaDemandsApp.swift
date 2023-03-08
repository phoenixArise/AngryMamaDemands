//
//  AngryMamaDemandsApp.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-07.
//

import SwiftUI

@main
struct AngryMamaDemandsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
