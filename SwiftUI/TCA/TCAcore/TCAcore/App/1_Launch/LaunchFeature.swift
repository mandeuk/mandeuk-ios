//
//  LaunchFeature.swift
//  TCAcore
//
//  Created by Inho Lee on 3/21/25.
//

import ComposableArchitecture

@Reducer
struct LaunchFeature {
    
    @ObservableState
    struct State {
    }
    
    enum Action {
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}
