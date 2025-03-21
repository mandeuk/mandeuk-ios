//
//  NumberView.swift
//  TCAcore
//
//  Created by Inho Lee on 3/19/25.
//
import SwiftUI
import ComposableArchitecture

struct NumberView: View {
    var store: StoreOf<NumberFeature>
    
    var body: some View {
        
        ZStack {
            Color.blue.opacity(0.3)
            
            VStack {
                Text("\(store.number)").padding(.top, 10)
                
                
                Spacer()
                
                Button(action: {
                    store.send(.goBackToMain)
                }, label: {
                    Text("BACK to Main")
                })
                .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    store.send(.goBack)
                }, label: {
                    Text("BACK")
                })
                .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    store.send(.plus)
                }, label: {
                    Text("Plus")
                })
                
                Spacer()
            }
        }
    }
}
