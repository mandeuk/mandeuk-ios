//
//  RootFeature.swift
//  TCAcore
//
//  Created by Inho Lee on 3/7/25.
//

import ComposableArchitecture

@Reducer
struct RootFeature {
    
    @Reducer
    enum Path {
        case login(LoginFeature)
        case main(MainFeature)
        case options(OptionsFeature)
    }
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>([.login(LoginFeature.State())])
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        
        case clickLogin
    }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            // Core logic for root feature
            switch action {
            case .path(.element(id: _, action: .login(.successLogin))):
                state.path.append(.main(MainFeature.State()))
                return .none
                
            case .clickLogin:
                state.path.append(.login(LoginFeature.State()))
                return .none
                
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}


@Reducer
struct LoginFeature {
    @ObservableState
    struct State {
        
    }
    enum Action {
        case clickLogin
        case successLogin
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .clickLogin:
                return .send(.successLogin)
            case .successLogin:
                return .none
            }
        }
    }
}

@Reducer
struct MainFeature {
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State {
        
    }
    enum Action {
        case clickBackButton
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .clickBackButton:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }
}

@Reducer
struct OptionsFeature {
    @ObservableState
    struct State {
        
    }
    enum Action {
        
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}
