//
//  NumberFeature.swift
//  TCAcore
//
//  Created by Inho Lee on 3/19/25.
//
import SwiftUI
import ComposableArchitecture

@Reducer
struct NumberFeature {
    @ObservableState
    struct State: Equatable {
        var number: Int = 0
    }
    
    enum Action {
        case navigate(NavigationAction)
        
        case goBack
        case goBackToMain
        case plus
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .navigate: return .none
                
                
            case .goBack:
                return .send(.navigate(.back))
            case .goBackToMain:
                print("NumberFeature goBackToMain")
                return .send(.navigate(.backTo(.main)))
            case .plus:
                return .send(.navigate(.next([.number(.init(number: state.number+1))])))
            }
        }
    }
    
//    func build(_ parameter: [String:Any]?) -> State {
//        if let param = parameter, let number = param["number"] as? Int {
//            return .init(number: number)
//        }
//        else {
//            return .init(number: 0)
//        }
//    }
}
//
//func numberBuilder(_ parameter: [String:Any]?) -> NumberFeature.State {
//    if let param = parameter, let number = param["number"] as? Int {
//        return .init(number: number)
//    }
//    else {
//        return .init(number: 0)
//    }
//}
