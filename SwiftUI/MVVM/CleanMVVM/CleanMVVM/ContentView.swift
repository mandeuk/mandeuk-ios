//
//  ContentView.swift
//  CleanMVVM
//
//  Created by Inho Lee on 6/2/25.
//

import SwiftUI
import Shared

struct ContentView: View {
    let useCase = KoinHelper.shared.getRandomNumberUseCase()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button(action: {
                useCase.invoke { kInt, err in
                    if let int = kInt?.intValue {
                        print("@LOG kInt = \(int)")
                    }
                }
            }, label: {
                Text("TestButton")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
