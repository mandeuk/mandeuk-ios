//
//  RootView.swift
//  TCAcore
//
//  Created by Inho Lee on 3/7/25.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    @Bindable var store: StoreOf<RootFeature>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            // Root view of the navigation stack
            VStack {
                Button(action: {
                    store.send(.navigate(.next([.login(.init())])))
                }, label: {
                    Text("Login")
                })
                
                Button(action: {
                    store.send(.navigate(.next([.main(.init())])))
                }, label: {
                    Text("Main")
                })
                
                Button(action: {
                    store.send(.navigate(.next([.number(.init())])))
                }, label: {
                    Text("Number")
                })
            }
        } destination: { store in
            // A view for each case of the Path.State enum
            switch store.case {
            case .login(let store):
                LoginView(store: store)
            case .main(let store):
                MainView(store: store)
            case .options(let store):
                OptionsView(store: store)
            case .number(let store):
                NumberView(store: store)
            }
        }
//        .overlay {
//            VStack {
//                Text("\(store.path)")
//                Spacer()
//            }
//        }
    }
}
