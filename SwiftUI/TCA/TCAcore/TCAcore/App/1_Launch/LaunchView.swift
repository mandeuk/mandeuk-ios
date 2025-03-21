//
//  LaunchView.swift
//  TCAcore
//
//  Created by Inho Lee on 3/21/25.
//

import SwiftUI
import ComposableArchitecture

struct LaunchView: View {
    var store: StoreOf<LaunchFeature>
    
    var body: some View {
        ZStack {
            Color.red.opacity(0.3)
            
            VStack{
                Text("Login View")
                Spacer()
                Button(action: {
                }, label: {
                    Text("Test Multiple navigation")
                })
                Spacer()
                Button(action: {
                }, label: {
                    Text("Replace to Main")
                })
                Spacer()
            }
        }
    }
}
