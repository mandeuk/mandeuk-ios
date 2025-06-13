import SwiftUI

#Preview {
    LoginView()
}

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
            Text(router.currentStack())
            
            Spacer()
            
            Text("\(isLatestVersion ? "true" : "false")")
            Button {
                router.routeTo(.main)
            } label: {
                Text("Route To Main View")
                    .padding(16)
            }
            .buttonStyle(.bordered)
            Button {
                router.back()
            } label: {
                Text("Back")
                    .padding(16)
            }
            .buttonStyle(.bordered)
            Button {
                router.backToRoot()
            } label: {
                Text("Back To Root")
                    .padding(16)
            }
            .buttonStyle(.bordered)
            
            Button {
                router.backToFirst(.login)
            } label: {
                Text("Back To First LOGIN")
                    .padding(16)
            }
            .buttonStyle(.bordered)
            Button {
                router.backToLast(.login)
            } label: {
                Text("Back To Last LOGIN")
                    .padding(16)
            }
            .buttonStyle(.bordered)
            Button {
                router.backToLast(.main)
            } label: {
                Text("Back To Last MAIN")
                    .padding(16)
            }
            .buttonStyle(.bordered)
            
            Spacer()
        }
        .toolbar(.hidden, for: .navigationBar)
    }// end of Body
}


// MARK: Action
extension LaunchView {
    // something..
}


// MARK: API
extension LaunchView {
    // something..
}
