//
//  CleanMVVMApp.swift
//  CleanMVVM
//
//  Created by Inho Lee on 6/2/25.
//

import SwiftUI
import Shared

@main
struct CleanMVVMApp: App {
    
    init() {
        KoinInitKt.doInitKoin()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
