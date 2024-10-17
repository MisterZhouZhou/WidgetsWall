//
//  Modifiers.swift
//  WidgetsWall
//
//  Created by on 2024/10/17.
//

import SwiftUI

@available(iOS 15.0.0, *)
struct BaseShadowModifier: ViewModifier {
    let color: SwiftUI.Color
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: 6, x: 0, y: 3)
            .shadow(color: color, radius: 1, x: 0, y: 1)
    }
}
