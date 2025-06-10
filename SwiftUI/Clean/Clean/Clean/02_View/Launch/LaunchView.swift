import SwiftUI

// MARK: State
struct LaunchView {
    @State var isLatestVersion: Bool = true
}

// MARK: View
extension LaunchView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("LaunchView")
            Text("\(isLatestVersion ? "true" : "false")")
        }
        .padding()
        .task {
            await requestAPI()
        }
    }
}

// MARK: API
extension LaunchView {
    private func requestAPI() async {
        let result = await APIClient.execute( GetIosVersionCheckModel(parameters: .init()) )
        switch result {
        case let .success(response):
            print("@LOG \(response)")
            guard
                let data = response.data?.data,
                let isForce = data.isForce,
                let version = data.version
            else {
                print("@LOG \(#function) - guard failed")
                break
            }
            
            print("@LOG \(#function) - success")
            // 데이터 비교
            await successGetAppVersion(version)
            
            return
        case let .failure(error):
            print("@LOG \(#function) - failure \(error.statusCode) - \(error.message)")
            break
        }
        return shutdownApp()
    }
    
    @MainActor
    private func successGetAppVersion(_ version: String) {
        print("@LOG \(#function) - isMainThread : \(Thread.current.isMainThread)")
        isLatestVersion = compareAppVersion(version)
    }
}

#Preview {
    LaunchView()
}
