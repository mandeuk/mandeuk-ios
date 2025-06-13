//
//  CleanApp.swift
//  Clean
//
//  Created by Inho Lee on 6/4/25.
//

import SwiftUI

@main
struct CleanApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var routeManager: RouteManager = .init()
}

extension CleanApp {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(routeManager)
                .onOpenURL { url in
                    guard let component = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                        print("Deeplink - parse miss")
                        return
                    }
                    
                    let pathList = component.path.split(separator: "/").map(String.init)
                    let queryItem: [String: String] = component.queryItems?.reduce([:]) { curr, next -> [String: String] in
                        guard let value = next.value else { return curr }
                        return curr.merging([next.name: value]) { $1 }
                    } ?? [:]
                    
                    //saveDeeplinkData(pathList: pathList, items: queryItem)
                }
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .active:
                        print("ScenePhase : active")
                    case .inactive:
                        print("ScenePhase : inactive")
                    case .background:
                        print("ScenePhase : background")
                    @unknown default:
                        fatalError()
                    }
                }
                .onContinueUserActivity("") { userActivity in
                }
        }// end of WindowGroup
    }
}
