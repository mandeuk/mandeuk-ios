//
//  MainView.swift
//  TCAcore
//
//  Created by Inho Lee on 3/19/25.
//
import SwiftUI
import ComposableArchitecture

struct MainView: View {
    var store: StoreOf<MainFeature>
    
    var body: some View {
        
        ZStack {
            Color.green.opacity(0.3)
            
            
            VStack {
                Text("Main View")
                Spacer()
                Button(action: {
                    store.send(.clickBackButton)
                }, label: {
                    Text("BACK")
                })
                .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    store.send(.clickNumberButton)
                }, label: {
                    Text("Number")
                })
                
                Spacer()
                
                WKWebViewPractice(url: "https://forma.dl.it.unity3d.com/")
            }
        }
    }
}
