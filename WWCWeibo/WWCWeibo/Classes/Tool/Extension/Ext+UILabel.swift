//
//  Ext+UILabel.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/23.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit
extension UILabel {
    
    /// 快捷创建UILabel
    ///
    /// - parameter text:      内容文字
    /// - parameter fontSize:  字体大小
    /// - parameter textColor: 字体颜色
    ///
    /// - returns: UILabel
    convenience init(text: String, fontSize: CGFloat, textColor: UIColor, maxWidth: CGFloat = 0) {
        self.init()
        self.text = text
        self.numberOfLines = 0
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
        if maxWidth > 0 {
            self.preferredMaxLayoutWidth = maxWidth
            self.numberOfLines = 0
        }
    }
}
