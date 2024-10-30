//
//  CharingShortcutWindow.swift
//  WidgetsWall
//
//  Created by on 2024/10/30.
//  充电动画window

import UIKit
import SwiftUI

// 定义充电动画视图
struct ChargingAnimationView: View {
    let onClose: () -> Void

    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.5
    
    var body: some View {
        ZStack {
            // 背景
            Color.black.edgesIgnoringSafeArea(.all)
            
            // 电池动画
            VStack {
                Image(systemName: "battery.100.bolt")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("充电中...")
                    .foregroundColor(.white)
                    .font(.title)
                    .opacity(opacity)
            }
        }
        .onTapGesture {
            // 关闭window
            onClose()
        }
        .onAppear {
            // 创建循环动画
            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                scale = 1.2
                opacity = 1.0
            }
        }
    }
}

// 用于管理窗口的单例类
class WindowManager: ObservableObject {
    static let shared = WindowManager()
    private var additionalWindow: UIWindow?
    @Published var isWindowVisible = false
    
    func showWindow() {
        guard additionalWindow == nil else { return }
        
        // 获取当前 key window 的场景,会出现获取的activationState是非激活状态,这里暂时先不做处理
        guard let windowScene = UIApplication.shared.connectedScenes
            // .filter({ $0.activationState == .foregroundInactive })
            .first as? UIWindowScene else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
        
        // 创建承载 SwiftUI 视图的控制器
        let contentView = ChargingAnimationView {
            self.hideWindow()
        }
        let hostingController = UIHostingController(rootView: contentView)
        
        window.rootViewController = hostingController
        // window.backgroundColor = .black  // 确保窗口有背景色
        // window.windowLevel = .alert + 1  // 设置较高的窗口层级
        window.frame = windowScene.coordinateSpace.bounds
        
        // 使窗口可见
        window.makeKeyAndVisible()
        window.isHidden = false
        
        self.additionalWindow = window
        self.isWindowVisible = true
    }
    
    func hideWindow() {
        additionalWindow?.isHidden = true
        additionalWindow = nil
        isWindowVisible = false
    }
}
