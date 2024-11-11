//
//  WWJavaScriptCore.swift
//  WidgetsWall
//
//  Created by on 2024/10/30.
//  JavaScriptCore 学习

import SwiftUI
import JavaScriptCore

@objc protocol UserJSSwiftDelegate : JSExport{
   var name:(String){get set};
   var age:(Int){get set};
   func callSystemCamera();
   func showAlert(title:String,msg:String);
   func callWithDict(dic:[String:AnyObject]);
   func descriptions();
}

@objc class User: NSObject, UserJSSwiftDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var name: (String)

    var age: (Int)
    
    var jsContext:JSContext?
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func callSystemCamera() {
        let imagePickerViewController = UIImagePickerController();
        imagePickerViewController.delegate = self;
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.keyWindow
        
        keyWindow?.addSubview(imagePickerViewController.view);
        keyWindow?.rootViewController?.addChild(imagePickerViewController);
    }
    
    func showAlert(title: String, msg: String) {
        let jsValue = self.jsContext?.objectForKeyedSubscript("alertFunc");
        jsValue?.call(withArguments: [title, msg]);
    }
    
    func callWithDict(dic: [String : AnyObject]) {
        let funStr = "var swiftInsertIntoJsFunc = function(arg){" +
       "document.getElementById('swiftInsertIntoJsSpan').innerHTML = arg['name'];" +
       "}";
       // 插入JS
       self.jsContext?.evaluateScript(funStr);
       let jsFunc = self.jsContext?.objectForKeyedSubscript("swiftInsertIntoJsFunc");
       jsFunc?.call(withArguments: [dic]);
    }
    
    func descriptions() {
        print("----")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.view.removeFromSuperview();
        picker.removeFromParent();
    }
}

@objc protocol MathToolsExport: JSExport {
    func add(_ a: Int, _ b: Int) -> Int
    var multiplier: Int { get set }
}

@objc class MathTools: NSObject, MathToolsExport {
    var multiplier: Int = 1
    
    func add(_ a: Int, _ b: Int) -> Int {
        return (a + b) * multiplier
    }
}


struct WWJavaScriptCore: View {
    
    let context: JSContext = JSContext()
    
    init() {
        // 异常捕获
        self.context.exceptionHandler = { context, exception in
            print("JS Error: \(exception?.toString() ?? "")")
        }
    }
    
    func runJS() {
      // 注入全局变量
      context.setObject(3.14, forKeyedSubscript: "PI" as NSString)
          
      // 执行JavaScript代码
      context.evaluateScript("var result = PI * 2;")
      
      // 获取JavaScript中的值
      if let result = context.objectForKeyedSubscript("result").toNumber() {
          print("计算结果：\(result)")
      }
        
//        let js = "2+2"
//        let result:JSValue = self.context.evaluateScript(js)
//        print(result, result.toObject() as Any)
    }
    
    func runJSArray() {
        // let result: JSValue = self.context.evaluateScript("var array = ['徐海青',123]")
        // print(result) // 返回undefined
        
        self.context.evaluateScript("var array = ['程序员小溪', 12]")
        // 获取数组变量
        let arrayVal: JSValue = context.objectForKeyedSubscript("array")
        guard arrayVal.isArray else {
            print("arrayValue不是数组")
            return
        }
        print(arrayVal) // 程序员小溪,12
        
        // 获取数组的长度
        print(arrayVal.objectForKeyedSubscript("length")!) // 2
        // 获取数组内容
        print(arrayVal.objectAtIndexedSubscript(0)!, arrayVal.objectAtIndexedSubscript(1)!) // 程序员小溪 12
        
        // 数组扩展
        arrayVal.setObject("公众号", atIndexedSubscript: 2)
        print(arrayVal) // 程序员小溪,12,公众号
        
        // jsvalue 转数组
        let result: [Any] = arrayVal.toArray()
        print(result)
    }
    
    // 执行js函数
    func runJSMethod() {
        let funStr = """
        var fun = function(value) {
            if (value < 0) return;
            if (value === 0) return 1;
            return value * fun(value-1);
        }
        """
        // 执行js
        self.context.evaluateScript(funStr)
        // 获取函数变量
        let jsFun: JSValue = self.context.objectForKeyedSubscript("fun")
        // 执行函数
        let result: JSValue = jsFun.call(withArguments: [3])
        print(result) // 6
    }
    
    // 注入闭包
    func runJSBlock () {
        let block = {(name:String, age:Int) -> JSValue in
            guard let object = JSValue(newObjectIn: self.context) else {
                return JSValue(nullIn: self.context)
            }
            object.setObject(name, forKeyedSubscript: "name");
            object.setValue(age, forProperty: "age");
            return object;
        }

        // 执行js
        self.context.setObject(block("程序员小溪", 18), forKeyedSubscript: "user" as NSString);
        let user: JSValue = self.context.evaluateScript("user");
        print(user.objectForKeyedSubscript("name") as JSValue, user.objectForKeyedSubscript("age") as JSValue)
        // 程序员小溪 18
    }
    
    // JSExport
    func runJSExport() {
        let user = User(name: "程序员小溪", age: 18)
        // 执行js
        self.context.setObject(user, forKeyedSubscript: "user" as NSString);
        let userResult: JSValue = self.context.evaluateScript("user");
        print(userResult.objectForKeyedSubscript("name") as JSValue, userResult.objectForKeyedSubscript("age") as JSValue)
        let jsMethod = """
            user.callSystemCamera();
        """
        self.context.evaluateScript(jsMethod)
    }
    
    func runJSExportMethod() {
        let mathTools = MathTools()
        self.context.setObject(mathTools, forKeyedSubscript: "math" as NSString)
        let jsMethod = """
            math.multiplier = 2;
            var result = math.add(3, 4);
            result;
        """
        let result = self.context.evaluateScript(jsMethod)
        // 打印结果
        if let value = result?.toInt32() {
            print("计算结果：\(value)")
        }
    }
    
    func runJSVM() {
//        let vm = JSVirtualMachine()
//        guard let context1 = JSContext(virtualMachine: vm) else {
//            return
//        }
//        guard let context2 = JSContext(virtualMachine: vm) else {
//            return
//        }
//        // 多个Context可以并发执行，但同一个VM中的JavaScript代码是串行的
//        DispatchQueue.global().async {
//            if let result = context1.evaluateScript("2+2") {
//                print("result1:\(result)")
//            }
//        }
//        DispatchQueue.global().async {
//            if let result = context2.evaluateScript("3+3") {
//                print("result2:\(result)")
//            }
//        }
        
        // 注入原生函数到JavaScript
        let log: @convention(block) (String) -> Void = { message in
            print("JavaScript日志: \(message)")
        }
        context.setObject(log, forKeyedSubscript: "nativeLog" as NSString)
        
        // 执行JavaScript代码
        context.evaluateScript("""
            function testBridge() {
                nativeLog('Hello from JavaScript!');
            }
        """)
        
        // 调用JavaScript函数
        context.objectForKeyedSubscript("testBridge")?.call(withArguments: [])
    }
    
    // 长期保存的js对象
    func runJSObject() {
        let virtualMachine: JSVirtualMachine = JSVirtualMachine()
        let context: JSContext =  JSContext(virtualMachine: virtualMachine)
        var managedValues: [JSManagedValue] = []
        
        // 创建一个要长期保存的 JavaScript 对象
        guard let jsObject = context.evaluateScript("({ data: 'some data' })") else {
           return
        }
       
        // 创建托管值
        let managedValue: JSManagedValue = JSManagedValue(value: jsObject)
       
        // 添加到内存管理
        virtualMachine.addManagedReference(managedValue, withOwner: self)
       
        // 保存引用
        managedValues.append(managedValue)
    }
    
    var body: some View {
        Button {
            runJS()
        } label: {
            Text("执行JSContext")
        }
        Button {
            runJSArray()
        } label: {
            Text("执行JSContext Array")
        }
        Button {
            runJSMethod()
        } label: {
            Text("执行JSContext Method")
        }
        Button {
            runJSBlock()
        } label: {
            Text("执行JSContext Block")
        }
        Button {
            runJSExportMethod()
        } label: {
            Text("执行JSExport Method")
        }
        Button {
            runJSExport()
        } label: {
            Text("执行JSExport")
        }
        Button {
            runJSVM()
        } label: {
            Text("执行JSVM")
        }
        Button {
            runJSObject()
        } label: {
            Text("执行JSVM")
        }
    }
}

#Preview {
    WWJavaScriptCore()
}
