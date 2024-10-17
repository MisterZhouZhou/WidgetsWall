//
//  View+.swift
//  WidgetsWall
//
//  Created by on 2024/10/17.
//

import SwiftUI

@available(iOS 15.0.0, *)
extension View {
    func baseShadow(color: SwiftUI.Color = .black.opacity(0.3)) -> some View {
        modifier(BaseShadowModifier(color: color))
    }
}
