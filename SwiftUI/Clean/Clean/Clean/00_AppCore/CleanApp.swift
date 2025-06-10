//
//  CleanApp.swift
//  Clean
//
//  Created by Inho Lee on 6/4/25.
//

import SwiftUI

@main
struct CleanApp: App {
//    @State var path: NavigationPath = NavigationPath(["Launch"])
    @StateObject private var routeManager: RouteManager = .init()
}

extension CleanApp {
    var body: some Scene {
        WindowGroup {
            RouterView()
                .environmentObject(routeManager)
        }
    }
}
