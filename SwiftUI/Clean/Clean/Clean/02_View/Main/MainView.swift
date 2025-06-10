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
            Text(router.current())
            Text(testData.id.formatted())
            Text(testData.name)
            Text(testData.age.formatted())
            Button {
                router.routeTo(.login)
            } label: {
                Text("Route To Login View")
                    .padding(16)
            }
            Button {
                router.backLatest()
            } label: {
                Text("Back")
                    .padding(16)
            }
            Button {
                print(testData)
                self.testData.updateParam(param)
                print(testData)
            } label: {
                Text("Print")
                    .padding(16)
            }
        }
        .padding()
        .task {
//            self.testData.updateParam(param)
        }
    }
}
