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
                    store.send(.navigate(.init(action: .next, paths: [.login])))
                }, label: {
                    Text("Login")
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
        .environment(\.navigator, store)
//        .overlay {
//            VStack {
//                Text("\(store.path)")
//                Spacer()
//            }
//        }
    }
}






private struct MyRootKey: EnvironmentKey {
    static let defaultValue = StoreOf<RootFeature>.init(
        initialState: RootFeature.State(),
        reducer: { RootFeature() }
    )
}

extension EnvironmentValues {
    var navigator: StoreOf<RootFeature> {
        get { self[MyRootKey.self] }
        set { self[MyRootKey.self] = newValue }
    }
}
