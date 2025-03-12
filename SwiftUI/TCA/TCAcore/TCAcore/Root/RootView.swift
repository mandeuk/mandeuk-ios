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
                    store.send(.clickLogin)
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
            }
        }
        .overlay {
            VStack {
                Text("Overlay")
                Spacer()
            }
        }
    }
}


struct LoginView: View {
    var store: StoreOf<LoginFeature>
    
    var body: some View {
        ZStack {
            Color.red.opacity(0.3)
            
            Button(action: {
                store.send(.clickLogin)
            }, label: {
                Text("Press LOGIN")
            })
        }
    }
}

struct MainView: View {
    var store: StoreOf<MainFeature>
    
    var body: some View {
        
        ZStack {
            Color.green.opacity(0.3)
            
            Button(action: {
                store.send(.clickBackButton)
            }, label: {
                Text("BACK")
            })
        }
    }
}

struct OptionsView: View {
    var store: StoreOf<OptionsFeature>
    
    var body: some View {
        
        ZStack {
            Color.blue.opacity(0.3)
        }
    }
}
