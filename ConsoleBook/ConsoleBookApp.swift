//
//  ConsoleBookApp.swift
//  ConsoleBook
//
//  Created by Cha Jung Tae on 1/8/22.
//

import SwiftUI

@main
struct ConsoleBookApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
