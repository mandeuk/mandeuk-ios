//
//  TCAcoreApp.swift
//  TCAcore
//
//  Created by Inho Lee on 3/7/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAcoreApp: App {
    
    static let store = Store(initialState: RootFeature.State()) {
        RootFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(store: TCAcoreApp.store)
        }
    }
}
