import SwiftUI

// MARK: State
struct MainView {
    @EnvironmentObject var router: RouteManager
    @State var isLatestVersion: Bool = true
    @State var testData: TestData
    var param: [String:Any]? = nil
    
    init(_ param: [String:Any]?) {
        self.param = param
        self.testData = TestData(param)
    }
}

// MARK: View
extension MainView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("MainView")
            Text(router.currentStack())
            
            Spacer()
            
            Text(testData.id.formatted())
            Text(testData.name)
            Text(testData.age.formatted())
            Button {
                router.routeTo(.login)
            } label: {
                Text("Route To Login View")
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
                router.backToFirst(.main)
            } label: {
                Text("Back To First MAIN")
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
            Button {
                router.backToLast(.login)
            } label: {
                Text("Back To Last login")
                    .padding(16)
            }
            .buttonStyle(.bordered)
            
            Button {
                print(testData)
                self.testData.updateParam(param)
                print(testData)
            } label: {
                Text("Print")
                    .padding(16)
            }
//            .buttonStyle(.bordered)
            
            Spacer()
        }// end of VStack
        .toolbar(.hidden, for: .navigationBar)
    }// end of Body
}


// MARK: Action
extension MainView {
    // something..
}


// MARK: API
extension MainView {
    // something..
}
