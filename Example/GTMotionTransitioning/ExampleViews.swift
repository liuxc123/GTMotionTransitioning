//
//  ExampleViews.swift
//  GTMotionTransitioning_Example
//
//  Created by liuxc on 2018/8/14.
//  Copyright © 2018年 liuxc123. All rights reserved.
//

import UIKit

func createExampleView() -> UIView {
    let view = UIView(frame: .init(x: 0, y: 0, width: 128, height: 128))
    view.backgroundColor = .primaryColor
    view.layer.cornerRadius = view.bounds.width / 2
    return view
}

func createExampleSquareView() -> UIView {
    let view = UIView(frame: .init(x: 0, y: 0, width: 128, height: 128))
    view.backgroundColor = .primaryColor
    return view
}
