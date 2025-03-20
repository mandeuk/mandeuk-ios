//
//  RootFeature.swift
//  TCAcore
//
//  Created by Inho Lee on 3/7/25.
//

import ComposableArchitecture

@Reducer
struct RootFeature {
    @ObservableState
    struct State {
        var path = StackState<Path.State>([.login(LoginFeature.State())])
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        
        case navigate(NavigationAction)
        
        case append([Path.State])
        case removeLast
        case prefix(PathName)
        case replace([Path.State])
    }
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
                // MARK: Navigate 신호 수신
            case .path(.element(id: _, action: .login(.navigate(let option)))):
                return .send(.navigate(option))
            case .path(.element(id: _, action: .main(.navigate(let option)))):
                return .send(.navigate(option))
            case .path(.element(id: _, action: .number(.navigate(let option)))):
                return .send(.navigate(option))
                
            
                
                
                // MARK: Navigate 신호 분류
            case .navigate(let option):
                switch option {
                case .next(let paths):
                    return .send(.append(paths))
                case .back:
                    return .send(.removeLast)
                case .backTo(let path):
                    return .send(.prefix(path))
                case .replace(let paths):
                    return .send(.replace(paths))
                }
                
                
                
                // MARK: Navigate 동작 수행
            case .append(let paths):
                state.path.append(contentsOf: paths)
                return .none
            case .removeLast:
                state.path.removeLast()
                return .none
            case .prefix(let path):
                if let index = state.path.firstIndex(where: { ps in
                    return getPathId(from: ps) == path.rawValue
                }) {
                    state.path = StackState<Path.State>(state.path.prefix(through: index))
                }
                return .none
            case .replace(let paths):
                state.path.removeAll()
                state.path.append(contentsOf: paths)
                return .none
                
                
                
            case .path: return .none // Do nothing, Must positioned last of the switch
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    private func buildPathList(_ option: [Path.State]) -> [Path.State]? {
        guard !option.isEmpty else { return nil }
        
        var list:[Path.State] = []
        
        option.forEach { path in
            switch path {
            case .login:
                list.append(.login(LoginFeature.State()))
                break
            case .main:
                list.append(.main(MainFeature.State()))
                break
            case .number:
                list.append(.number( NumberFeature.State()) )
                break
            case .options:
                list.append(.options(OptionsFeature.State()))
                break
            }
        }
        
        return list.isEmpty ? nil : list
    }
}

@Reducer
enum Path {
    case login(LoginFeature)
    case main(MainFeature)
    case options(OptionsFeature)
    case number(NumberFeature)
}
enum PathName: String {
    case login
    case main
    case options
    case number
}
func getPathId(from state: Path.State) -> String {
    switch state {
    case .login:
        return PathName.login.rawValue
    case .main:
        return PathName.main.rawValue
    case .options:
        return PathName.options.rawValue
    case .number:
        return PathName.number.rawValue
    }
}
func getPathId(from path: Path) -> String {
    switch path {
    case .login:
        return PathName.login.rawValue
    case .main:
        return PathName.main.rawValue
    case .options:
        return PathName.options.rawValue
    case .number:
        return PathName.number.rawValue
    }
}


enum NavigationAction {
    case next([Path.State])
    case back
    case backTo(PathName)
    case replace([Path.State])
}
