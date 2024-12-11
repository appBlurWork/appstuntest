//
//  File.swift
//  
//
//  Created by Bora Erdem on 5.02.2024.
//

import UIKit

final class ClickListener: UITapGestureRecognizer {
    private var action: () -> Void

    init(_ action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc
    private func execute() {
        action()
    }
}

public extension UIView {
    func onTapGesture(_ action: @escaping () -> Void) {
        self.isUserInteractionEnabled = true
        let click = ClickListener(action)
        self.addGestureRecognizer(click)
    }
}
