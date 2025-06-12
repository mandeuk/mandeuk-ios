//
//  Router.swift
//  Clean
//
//  Created by Inho Lee on 6/5/25.
//

import SwiftUI
import Combine

struct RouterView: View {
    @EnvironmentObject var router: RouteManager
    
    @Namespace var namespace
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                Text("This is NavigationStack View")
                Button {
                    router.routeTo(.launch)
                } label: {
                    Text("Route To Launch View")
                }
                
                NavigationLink(value: Route.login.rawValue) {
                    if #available(iOS 18.0, *) {
                        Text("NavigationLink to Login")
                            .matchedTransitionSource(id: 1, in: namespace)
                    } else {
                        Text("NavigationLink to Login")
                        // Fallback on earlier versions
                    }
                }
                
                Button {
                    router.routeTo(.login)
                } label: {
                    if #available(iOS 18.0, *) {
                        Text("Route To Login View")
                    } else {
                        Text("Route To Login View")
                        // Fallback on earlier versions
                    }
                }
                
                Button {
                    router.routeTo(.main, param: TestData(id: 1, name: "inho", age: 32).toParam() )
                } label: {
                    Text("Route To Main View")
                }
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                case Route.launch.rawValue: LaunchView()
                case Route.login.rawValue: LoginView()
                case Route.main.rawValue: MainView(router.getParam())
                    
                default:
                    Text("This is a string screen with value: \(value)")
                        .onAppear{
                            shutdownApp()
                        }
                }
            }
            .onAppear {
                if router.path.isEmpty {
                    router.routeTo(.launch)
                }
            }
        }
    }
}

//extension RouterView {
//    func routeTo(_ route: Route) {
//        path.append(route.rawValue)
//    }
//}

enum Route: String {
    case launch
    case login
    case main
}

@MainActor
final class RouteManager: ObservableObject {
    @Published var path: [String] = []
    var param: [String:Any]? = nil
    private var latestRouteTime: Date? = nil
    private var isRouting = false
    
    func getParam() -> [String:Any]? {
        return param
    }
    func setParam(_ param: [String:Any]) {
        self.param = param
    }
    

    private func safeRoute(_ action: @escaping () async -> Void) {
        //            print("@Thread \(#function) - \(DispatchQueue.currentLabel)")
        
        guard !isRouting else { return }
        
        isRouting = true
        
        Task { @MainActor in
            try await Task.sleep(for: .seconds(timeCheck(0.7)))
            await action()
            didRoute()
        }
    }
    private func timeCheck(_ delay: Double) -> Double {
        if let time = latestRouteTime,
           Date().timeIntervalSince(time) <= delay
        {
            let interval = delay - Date().timeIntervalSince(time)
            let seconds = interval > 0 ? interval : 0
            return seconds
        }
        return 0
    }
    private func didRoute() {
        self.latestRouteTime = Date()
        isRouting = false
    }
    
    
    func routeTo(_ route: Route, param: [String:Any]? = nil) {
        self.param = param
        safeRoute {
            self.path.append(route.rawValue)
        }
    }
    func replaceRoute(_ route: Route, param: [String:Any]? = nil) {
        self.param = param
        safeRoute {
            self.path = [route.rawValue]
        }
    }
    
    
    func back() {
        safeRoute {
            self.path.removeLast()
        }
    }
    func backToRoot() {
        if let first = self.path.first {
            safeRoute { self.path = [first] }
        }
    }
    func backToFirst(_ route: Route) {
        if let index = self.path.firstIndex(of: route.rawValue) {
            safeRoute {
                self.path.removeSubrange((index + 1)..<self.path.count)
            }
        }
    }
    func backToLast(_ route: Route) {
        if let index = self.path.lastIndex(of: route.rawValue) {
            safeRoute {
                self.path.removeSubrange((index + 1)..<self.path.count)
            }
        }
    }
    
    
    func current() -> String {
        var result: String = ""
        path.forEach { route in
            result += "\(route)/"
        }
        return result
    }
}

struct TestData: Codable {
    var id: Int
    var name: String
    var age: Int
    
    init(id: Int, name: String, age: Int) {
        self.id = id
        self.name = name
        self.age = age
    }
    init(_ param: [String:Any]?) {
        self.id = param?["id"] as? Int ?? 0
        self.name = param?["name"] as? String ?? ""
        self.age = param?["age"] as? Int ?? 0
    }
    
    
    func toParam() -> [String:Any] {
        [
            "id": id,
            "name": name,
            "age": age
        ]
    }
    mutating func updateParam(_ param: [String:Any]?) {
        self.id = param?["id"] as? Int ?? 0
        self.name = param?["name"] as? String ?? ""
        self.age = param?["age"] as? Int ?? 0
    }
}
