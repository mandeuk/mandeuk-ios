//
//  CustomFunc.swift
//  Clean
//
//  Created by Inho Lee on 6/9/25.
//

import SwiftUI

// MARK: 앱 강제종료
func shutdownApp() {
    Task { @MainActor in
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        try await Task.sleep(nanoseconds: 500_000_000)
        exit(0)
    }
}

// MARK: 앱 버전 비교
func localAppVersion() -> String {
    guard
        let dictionary = Bundle.main.infoDictionary,
        let version = dictionary["CFBundleShortVersionString"] as? String
    else {
        return "err"
    }
    
    return version
}
func compareAppVersion(_ version: String) -> Bool {
    let currentVersion = localAppVersion()
    print("current: \(currentVersion), version: \(version)")
    let compareResult = currentVersion.compare(version, options: .numeric)
    switch compareResult {
    case .orderedAscending:// 옛날버전
//        print("현재 버전은 옛날 버전입니다.")
        break
        //        return .send(.openVersionDialog(isForce == 1))
    case .orderedDescending:// 최신버전 보다 미래
//        print("현재 버전은 미래 버전입니다.")
        return true
        //        return .send(.trySessionLogin)
    case .orderedSame:// 최신버전과 정확히 일치
//        print("현재 버전은 최신 버전입니다.")
        return true
        //        return .send(.trySessionLogin)
    }
    return false
}


extension DispatchQueue {
    static var currentLabel: String {
        String(cString: __dispatch_queue_get_label(nil), encoding: .utf8) ?? "unknown"
    }
}
