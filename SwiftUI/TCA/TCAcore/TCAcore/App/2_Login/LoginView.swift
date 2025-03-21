//
//  LoginView.swift
//  TCAcore
//
//  Created by Inho Lee on 3/19/25.
//
import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    var store: StoreOf<LoginFeature>
    
    var body: some View {
        ZStack {
            Color.red.opacity(0.3)
            
            VStack{
                Text("Login View")
                Spacer()
                Button(action: {
                    store.send(.clickMultiple)
                }, label: {
                    Text("Test Multiple navigation")
                })
                Spacer()
                Button(action: {
                    store.send(.clickLogin)
                }, label: {
                    Text("Replace to Main")
                })
                Spacer()
            }
        }
    }
}
