//
//  MainFeature.swift
//  TCAcore
//
//  Created by Inho Lee on 3/19/25.
//
import SwiftUI
import ComposableArchitecture

@Reducer
struct MainFeature {
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        case navigate(NavigationAction)
        case clickBackButton
        case clickNumberButton
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .navigate: return .none
                
            case .clickBackButton:
                return .run { _ in
                    await self.dismiss()
                }
            case .clickNumberButton:
                return .send(.navigate(.next([.number(.init(number: 1))])))
            }
        }
    }
}
