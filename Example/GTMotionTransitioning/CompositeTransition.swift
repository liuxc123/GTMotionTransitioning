//
//  CompositeTransition.swift
//  GTMotionTransitioning_Example
//
//  Created by liuxc on 2018/8/14.
//  Copyright © 2018年 liuxc123. All rights reserved.
//

import UIKit
import GTMotionTransitioning

class CompositeTransition: NSObject, Transition, TransitionWithCustomDuration {

    let transitions: [Transition]
    init(transitions: [Transition]) {
        self.transitions = transitions

        super.init()
    }

    func start(with context: TransitionContext) {
        transitions.forEach { context.compose(with: $0) }

        context.transitionDidEnd()
    }


    func transitionDuration(with context: TransitionContext) -> TimeInterval {
        let duration = transitions.flatMap { $0 as? TransitionWithCustomDuration }.map { $0.transitionDuration(with: context) }.max { $0 < $1 }
        if let duration = duration {
            return duration
        }
        return 0.35
    }

}
