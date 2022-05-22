//
//  iTaskyApp.swift
//  iTasky
//
//  Created by Ronak Harkhani on 22/05/22.
//

import SwiftUI

@main
struct iTaskyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
