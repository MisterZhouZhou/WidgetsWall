//
//  ContentView.swift
//  WidgetsWall
//
//  Created by on 2024/10/17.
//

import SwiftUI

// 主视图
struct ContentView: View {
    @StateObject private var windowManager = WindowManager.shared
    
    var body: some View {
        VStack {
            Text("主窗口")
                .font(.title)
            
            Button("打开新窗口") {
                windowManager.showWindow()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    ContentView()
}
