//
//  Movieisme_13_MApp.swift
//  Movieisme_13_M
//
//  Created by Fajer alQahtani on 03/07/1447 AH.
//

import SwiftUI
import SwiftData

@main
struct Movieisme_13_MApp: App {
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
            MovieView()
        }
        .modelContainer(sharedModelContainer)
    }
}
