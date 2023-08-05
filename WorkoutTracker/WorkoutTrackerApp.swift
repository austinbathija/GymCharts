//
//  WorkoutTrackerApp.swift
//  WorkoutTracker
//
//  Created by Austin  on 7/18/23.
//

import SwiftUI

@main
struct WorkoutTrackerApp: App {
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}

