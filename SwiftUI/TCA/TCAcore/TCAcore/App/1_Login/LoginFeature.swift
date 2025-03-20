//
//  LoginFeature.swift
//  TCAcore
//
//  Created by Inho Lee on 3/19/25.
//
import ComposableArchitecture

@Reducer
struct LoginFeature {
    
    @ObservableState
    struct State {
        var account: String = ""
        var password: String = ""
    }
    
    enum Action {
        case navigate(NavigationAction)
        case clickLogin
        case clickMultiple
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .navigate: return .none
                
            case .clickLogin:
                return .send(.navigate(.next([.main(MainFeature.State())]) ))
            case .clickMultiple:
                return .send(.navigate(.next([.number(.init(number: 1)), .number(.init(number: 2)), .main(MainFeature.State())]) ))
            }
        }
    }
}
