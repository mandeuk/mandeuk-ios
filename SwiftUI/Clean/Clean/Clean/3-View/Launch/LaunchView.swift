import SwiftUI
import Alamofire

// MARK: State
struct LaunchView {
    @EnvironmentObject var router: RouteManager
    @Namespace var namespace
    
    @State var isLatestVersion: Bool = true
}


// MARK: View
extension LaunchView: View {
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack(alignment: .center) {
                Color.BLUE_02.ignoresSafeArea(.all)
                Image("launch_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ScreenSize.width*0.7, alignment: .center)
            }
            .navigationDestination(for: String.self) { value in
                switch value {
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
                Task { await requestAPI() }
            }
        }
    }
}


// MARK: Action
extension LaunchView {
    
}


// MARK: API
extension LaunchView {
    private func requestAPI() async {
        let model = GetIosVersionCheckModel(
            parameters: .init()
        )
        
        let result = await APIClient.request( model )
        switch result {
        case .success(let res):
            successGetAppVersion(res.data?.version ?? "")
            return
        case .failure(let err):
            print("@LOG \(#function) - failure \(err.statusCode) - \(err.message)")
            break
        }
        return// shutdownApp()
    }
    
    @MainActor
    private func successGetAppVersion(_ version: String) {
        isLatestVersion = compareAppVersion(version)
        router.replaceRoute(.login)
    }
}
