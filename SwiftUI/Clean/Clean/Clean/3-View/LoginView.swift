import SwiftUI

#Preview {
    LoginView()
        .environmentObject(RouteManager())
}

// MARK: State
struct LoginView {
    @EnvironmentObject var router: RouteManager
    @Environment(\.apiClient) var apiClient
    @State var isLatestVersion: Bool = true
    @State var inputId: String = ""
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
            
            HStack {
                TextField(text: $inputId, label: {Text("테스트용 아이디")}).frame(maxWidth: .infinity)
                
                Button(action: {
                    Task {await requestLogin()}
                }, label: {
                    
                    Text("로그인")
                        .padding(16)
                })
                .buttonStyle(.bordered)
            }
            
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
extension LoginView {
    // something..
}


// MARK: API
extension LoginView {
    // something..
    private func requestLogin() async {
        do {
            guard let userId = Int(self.inputId) else {
                throw APIError(statusCode: 400, message: "bad inputId")
            }
            let _ = try await apiClient.request( DevLoginModel(parameters: .init(userId: userId)) )
            router.replaceRoute(.main)
        } catch {
            if let err = error.asAPIError {
                print("@LOG \(#function) - failure \(err.statusCode) - \(err.message)")
            }
        }
    }
}
