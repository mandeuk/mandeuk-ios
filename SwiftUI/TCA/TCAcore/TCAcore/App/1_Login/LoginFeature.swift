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
        case navigate(NavigationOption)
        case clickLogin
        case clickMultiple
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .navigate: return .none
                
            case .clickLogin:
                return .send(.navigate(.init(action: .replace, paths: [.main])))
            case .clickMultiple:
                return .send(.navigate(.init(action: .next, paths: [.number, .number, .main], parameter: ["number": 55])))
            }
        }
    }
}
