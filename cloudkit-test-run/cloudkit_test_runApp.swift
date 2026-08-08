//
//  cloudkit_test_runApp.swift
//  cloudkit-test-run
//
//  Created by T Krobot on 11/7/26.
//

import SwiftUI
import SwiftData

@main
struct cloudkit_test_runApp: App {
    var body: some Scene {
        WindowGroup {
            UsersView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
                .modelContainer(for: User.self)
        }
    }
}
