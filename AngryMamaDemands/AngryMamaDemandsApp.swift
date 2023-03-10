//
//  AngryMamaDemandsApp.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-07.
//

import SwiftUI

@main
struct AngryMamaDemandsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, CoreDataStack.shared.context)
        }
    }
}
