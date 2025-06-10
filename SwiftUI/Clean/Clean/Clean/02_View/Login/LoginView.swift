import SwiftUI

// MARK: State
struct LoginView {
    @EnvironmentObject var router: RouteManager
    @State var isLatestVersion: Bool = true
}

// MARK: View
extension LoginView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("LoginView")
            Text("\(isLatestVersion ? "true" : "false")")
            Button {
                router.routeTo(.main)
            } label: {
                Text("Route To Main View")
                    .padding(16)
            }
            Button {
                router.backLatest()
            } label: {
                Text("Back")
                    .padding(16)
            }
        }
        .padding()
        .task {
        }
    }
}
