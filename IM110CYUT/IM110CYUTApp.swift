//
//  IM110CYUTApp.swift
//  IM110CYUT
//
//  Created by Ｍac on 2023/11/24.
//

import SwiftUI



@main
struct IM110CYUTApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
