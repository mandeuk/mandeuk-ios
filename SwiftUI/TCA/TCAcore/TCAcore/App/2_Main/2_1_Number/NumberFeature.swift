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
        
        init(_ parameter: [String:Any]? = nil) {
            if let param = parameter, let number = param["number"] as? Int {
                self.number = number
            }
        }
    }
    
    enum Action {
        case navigate(NavigationOption)
        
        case goBack
        case goBackToMain
        case plus
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .navigate: return .none
                
                
            case .goBack:
                return .send(.navigate(.init(action: .back, paths: [])))
            case .goBackToMain:
                print("NumberFeature goBackToMain")
                return .send(.navigate(.init(action: .backTo, paths: [.main])))
            case .plus:
                return .send(.navigate(.init(action: .next, paths: [.number], parameter: ["number": state.number + 1])))
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
