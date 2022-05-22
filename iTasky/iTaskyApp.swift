//
//  iTaskyApp.swift
//  iTasky
//
//  Created by Ronak Harkhani on 22/05/22.
//

import SwiftUI

@main
struct iTaskyApp: App {
    
    let persistanceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistanceController.container.viewContext)
        }
    }
}
