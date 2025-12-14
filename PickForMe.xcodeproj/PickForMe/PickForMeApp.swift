//
//  PickForMeApp.swift
//  PickForMe
//
//  Created by Daniel Jochum on 12/9/25.
//

import SwiftUI
import CoreData

@main
struct PickForMeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
