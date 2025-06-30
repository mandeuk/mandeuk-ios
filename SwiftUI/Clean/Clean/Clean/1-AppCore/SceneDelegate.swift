import UIKit

class SceneDelegate: NSObject, ObservableObject, UIWindowSceneDelegate {
    var window: UIWindow?   // << contract of `UIWindowSceneDelegate`
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = windowScene.keyWindow   // << store !!!
        /// Unity와 window 연결해 줄 때 사용
    }
    
    
    // MARK: Universal link
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        guard let url = URLContexts.first?.url else { return }
    }
    
    

    // Inactive -> Active
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("[LifeCycle] - sceneDidBecomeActive - \(scene.activationState)")
        
        //백그라운드에 앱은 남아있는 상태에서 푸시 알림을 받았을 때
        if UserDefaults.standard.bool(forKey: "appClosed") == false {
            
        }
        else {
            UserDefaults.standard.setValue(false, forKey: "appClosed")
        }
    }
    
    // Active -> Inactive
    func sceneWillResignActive(_ scene: UIScene) {
        print("[LifeCycle] - sceneWillResignActive - \(scene.activationState)")
    }
    
    // Inactive -> Background
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("[LifeCycle] - sceneDidEnterBackground - \(scene.activationState)")
    }
    
    // Background -> Inactive
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("[LifeCycle] - sceneWillEnterForeground - \(scene.activationState)")
    }
    // Background -> Closed
    func sceneDidDisconnect(_ scene: UIScene) {
        print("[LifeCycle] - sceneDidDisconnect - \(scene.activationState)")
        UserDefaults.standard.setValue(true, forKey: "appClosed")
    }
    
}

