//
//  File.swift
//  
//
//  Created by Bora Erdem on 5.02.2024.
//

import UIKit
import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
public extension UIView {
    func asView() -> some View {
        UIViewWrapper(view: self)
    }
}

@available(iOS 13.0, tvOS 13.0, *)
public struct UIViewWrapper<UIViewType: UIView>: UIViewRepresentable {
    let view: UIViewType

    public func makeUIView(context: Context) -> UIViewType {
        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
