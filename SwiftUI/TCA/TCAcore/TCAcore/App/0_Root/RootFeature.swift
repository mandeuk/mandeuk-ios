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
        
        case navigate(NavigationOption)
        
        case append([Path.State])
        case removeLast
        case prefix(NavigationPath)
        case replace([Path.State])
    }
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            // Core logic for root feature
            switch action {
            case .path(.element(id: _, action: .login(.navigate(let option)))):
                return .send(.navigate(option))
            case .path(.element(id: _, action: .main(.navigate(let option)))):
                return .send(.navigate(option))
            case .path(.element(id: _, action: .number(.navigate(let option)))):
                return .send(.navigate(option))
                
                
            case .navigate(let option):
                switch option.action {
                case .next:
                    guard let list = buildPathList(option) else { break }
                    return .send(.append(list))
                case .back:
                    return .send(.removeLast)
                case .backTo:
                    guard let dest = option.paths.first else { break }
                    return .send(.prefix(dest))
                case .replace:
                    guard let list = buildPathList(option) else { break }
                    return .send(.replace(list))
                }
                return .none
                
                
                
                // MARK: 내부 동작 Action들
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
                
            case .path: return .none // do nothing
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    private func buildPathList(_ option: NavigationOption) -> [Path.State]? {
        guard !option.paths.isEmpty else { return nil }
        
        var list:[Path.State] = []
        
        option.paths.forEach { path in
            switch path {
            case .login:
                list.append(.login(LoginFeature.State()))
                break
            case .main:
                list.append(.main(MainFeature.State()))
                break
            case .number:
                list.append(.number( NumberFeature.State(option.parameter)) )
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
enum NavigationAction {
    case next
    case back
    case backTo
    case replace
}
enum NavigationPath: String {
    case login
    case main
    case options
    case number
}
struct NavigationOption {
    var action: NavigationAction
    var paths: [NavigationPath]
    var parameter: [String:Any]? = nil
}


func getPathId(from state: Path.State) -> String {
    switch state {
    case .login:
        return NavigationPath.login.rawValue
    case .main:
        return NavigationPath.main.rawValue
    case .options:
        return NavigationPath.options.rawValue
    case .number:
        return NavigationPath.number.rawValue
    }
}

func getPathId(from path: Path) -> String {
    switch path {
    case .login:
        return NavigationPath.login.rawValue
    case .main:
        return NavigationPath.main.rawValue
    case .options:
        return NavigationPath.options.rawValue
    case .number:
        return NavigationPath.number.rawValue
    }
}
