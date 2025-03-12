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
    var body: some Scene {
        WindowGroup {
            RootView(
                store: StoreOf<RootFeature>.init(
                    initialState: RootFeature.State(),
                    reducer: { RootFeature() }
                )
            )
        }
    }
}
