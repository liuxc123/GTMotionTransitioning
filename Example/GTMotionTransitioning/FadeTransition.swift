//
//  FadeTransition.swift
//  GTMotionTransitioning_Example
//
//  Created by liuxc on 2018/8/14.
//  Copyright © 2018年 liuxc123. All rights reserved.
//

import UIKit
import GTMotionTransitioning

class FadeTransition: NSObject, Transition {


    enum Style {
        case fadeIn
        case fadeOut
    }

    let target: TransitionTarget
    let style: Style
    init(target: TransitionTarget, style: Style = .fadeIn) {
        self.target = target
        self.style = style

        super.init()
    }

    convenience override init() {
        self.init(target: .foreView)
    }

    // The sole method we're expected to implement, start is invoked each time the view controller is
    // presented or dismissed.
    func start(with context: TransitionContext) {
        CATransaction.begin()

        CATransaction.setCompletionBlock {
            // Let UIKit know that the transition has come to an end.
            context.transitionDidEnd()
        }

        let fade = CABasicAnimation(keyPath: "opacity")

        fade.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        switch style {
        case .fadeIn:
            fade.fromValue = 0
            fade.toValue = 1
        case .fadeOut:
            fade.fromValue = 1
            fade.toValue = 0
        }

        if context.direction == .backward {
            let swap = fade.fromValue
            fade.fromValue = fade.toValue
            fade.toValue = swap
        }

        let targetView = target.resolve(with: context)

        // Add the animation...
        targetView.layer.add(fade, forKey: fade.keyPath)

        // ...and ensure that our model layer reflects the final value.
        targetView.layer.setValue(fade.toValue, forKeyPath: fade.keyPath!)

        CATransaction.commit()
    }
    

}
