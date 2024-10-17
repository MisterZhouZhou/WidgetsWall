//
//  GifImageView.swift
//  WidgetsWall
//
//  Created by on 2024/10/17.
//

import SwiftUI
import ClockHandRotationKit

func getGif(_ gifName: String) -> UIImage.GifResult? {
    guard gifName.count > 0 else { return nil }
    
    guard let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif") else {
        return nil
    }
    
    guard FileManager.default.fileExists(atPath: gifPath),
          let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath))
    else {
        return nil
    }
    
    return UIImage.decodeGIF(gifData)
}

struct GifImageView: View {
    var gifName: String // Bundle中 gif图片的名称
    var defaultImage: String // 默认图片
    
    var body: some View {
        if let gif = getGif(gifName) {
            GeometryReader { proxy in
                let width = proxy.size.width
                let height = proxy.size.height
                
                let arcWidth = max(width, height)
                let arcRadius = arcWidth * arcWidth
                let angle = 360.0 / Double(gif.images.count)
                
                ZStack {
                    ForEach(1...gif.images.count, id: \.self) { index in
                        Image(uiImage: gif.images[(gif.images.count - 1) - (index - 1)])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, minHeight: 0)
                            .mask(
                                ArcView(arcStartAngle: angle * Double(index - 1),
                                        arcEndAngle: angle * Double(index),
                                        arcRadius: arcRadius)
                                .stroke(style: .init(lineWidth: arcWidth * 1.1, lineCap: .square, lineJoin: .miter))
                                .frame(width: width, height: height)
                                .clockHandRotationEffect(period: .custom(gif.duration))
                                .offset(y: arcRadius) // ⚠️ 需要先进行旋转，再设置offset
                            )
                    }
                }
                .frame(width: width, height: height)
            }
        } else {
            Image(systemName: defaultImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct ArcView: Shape {
    var arcStartAngle: Double
    var arcEndAngle: Double
    var arcRadius: Double
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: arcRadius,
                    startAngle: .degrees(arcStartAngle),
                    endAngle: .degrees(arcEndAngle),
                    clockwise: false)
        return path
    }
}
