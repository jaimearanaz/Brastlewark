//
//  NewBrastlewarkApp.swift
//  NewBrastlewark
//
//  Created by Jaime Aranaz on 29/5/25.
//

import SwiftUI
import SwiftData
import Domain
import Data

@main
struct NewBrastlewarkApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
