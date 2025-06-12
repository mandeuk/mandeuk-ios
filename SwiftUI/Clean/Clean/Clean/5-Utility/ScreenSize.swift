import SwiftUI

struct ScreenSize {
    static var width = UIWindow.current?.screen.bounds.width ?? 0
    static var height = UIWindow.current?.screen.bounds.height ?? 0
    static var smallSize = {
        return ((UIScreen.current?.bounds.width ?? 0) < (UIScreen.current?.bounds.height ?? 0)) ? (UIScreen.current?.bounds.width ?? 0) : (UIScreen.current?.bounds.height ?? 0)
    }()
}

extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}

extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
