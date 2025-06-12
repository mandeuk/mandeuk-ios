//
//  CleanApp.swift
//  Clean
//
//  Created by Inho Lee on 6/4/25.
//

import SwiftUI

@main
struct CleanApp: App {
    // 시작 화면을 LaunchView가 아닌 다른 화면으로 변경하려면 RouteManager 파일을 확인하세요.
    @StateObject private var routeManager: RouteManager = .init()
}

extension CleanApp {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(routeManager)
        }
    }
}
