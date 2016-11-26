//
//  Ext+UIBarButtonItem.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/22.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 创建UIBarButtonItem的快捷方式
    ///
    /// - parameter highlightedImageName: 高亮图片的名字
    /// - parameter title:                title
    /// - parameter target:               监听者
    /// - parameter action:               监听事件
    ///
    /// - returns: customView为UIButton的UIBarButtonItem
    convenience init(setHighlightedImageName: String? = nil, title: String? = nil, target: Any?, action: Selector) {
        self.init()
        let btn = UIButton(setHighlightedImageName: setHighlightedImageName, title: title, target: target, action: action)
        self.customView = btn
    }
}
