//
//  RunJavaScriptShortcut.swift
//  WidgetsWall
//
//  Created by on 2024/11/8.
//  运行JavaScript

import AppIntents
import SwiftUI
import JavaScriptCore

struct RunJavaScriptShortcut: AppIntent {
    static var title = LocalizedStringResource("运行JavaScript")
    static var description = IntentDescription("运行JavaScript操作")
    
    @Parameter(title: "代码文本", description: "要执行的代码文本")
    var jsCcode: String?


    static var parameterSummary: some ParameterSummary {
        // 写法1 参数一行展示
        // Summary("运行JavaScript \(\.$jsCcode)")
        
        // 写法2 参数折叠展示,默认
        Summary("运行JavaScript") {
            \.$jsCcode
        }
    }
    
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        guard let jsCcode else {
            return .result(value: "")
        }
        // 执行js代码
        let reusltValue: JSValue = runJS(jsCcode)
        return .result(value: "\(reusltValue)")
    }
}

func runJS(_ jsCode: String) -> JSValue {
    let context: JSContext = JSContext()
    // 执行js
    let arrayVal: JSValue = context.evaluateScript(jsCode)
    print("result:", arrayVal)
    return arrayVal
}
