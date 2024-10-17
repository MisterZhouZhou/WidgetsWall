//
//  TimeNotifityView.swift
//  WidgetsWall
//
//  Created by on 2024/10/17.
//

import SwiftUI
import ActivityKit

struct TimeNotifityView: View {
    @State var progress: Float = 0.0;
    @State var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    private func startBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            // 如果任务时间到了，系统会调用这个回调
            self.endBackgroundTask()
        }
    }

    private func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundTask)
        self.backgroundTask = .invalid
    }
    
    // 定时任务,后台任务保证进度的正常进行
    private func tick() {
        guard progress < 1.0 else {
            endBackgroundTask()
            return
        }

        // 开始后台任务
        if backgroundTask == .invalid {
            startBackgroundTask()
        }

        // 继续定时任务
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.updateActivity()
            self.progress += 0.2  // 模拟进度增加
            self.tick()
        }
    }

    // 开始实时活动
    func startActivity() {
        // 静态数据
        let attributes = TimeNotifityAttributes(
            name: "iOS 小溪"
        )
        // 动态数据
        let initialContentState = TimeNotifityAttributes.ContentState(
            emoji: "😄",
            title: "开始实时活动通知",
            progress: 0
        )
        
        try? Activity.request(
            attributes: attributes,
            content: .init(state: initialContentState, staleDate: nil)
        )
    }
    
    // 更新实时活动
    func updateActivity(){
        Task{
            // 动态数据
            let updatedStatus = TimeNotifityAttributes.ContentState(
                emoji: "😂",
                title: "实时活动通知更新中",
                progress: self.progress
            )
            let content = ActivityContent<TimeNotifityAttributes.ContentState>(state: updatedStatus, staleDate: nil)
            for activity in Activity<TimeNotifityAttributes>.activities{
                await activity.update(content)
                print("更新成功,当前进度\(self.progress)")
            }
        }
    }
    
    // 结束实时活动
    func endActivity(){
        self.progress = 0;
        Task{
            for activity in Activity<TimeNotifityAttributes>.activities{
                await activity.end(nil, dismissalPolicy: .immediate)
                print("已关闭灵动岛显示")
            }
        }
    }
    
    var body: some View {
        VStack {
            ButtonViewBuilder(title: "启动灵动岛", action: startActivity)
            ButtonViewBuilder(title: "更新灵动岛", action: tick)
            ButtonViewBuilder(title: "关闭灵动岛", action: endActivity)
        }
        .padding()
    }
    
    func ButtonViewBuilder(title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .buttonStyle(.bordered)
    }
}

#Preview {
    TimeNotifityView()
}
