//
//  Ext+UIButton.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/22.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// 创建 button 快捷方式
    ///
    /// - parameter backgroundImageName: 背景图片
    /// - parameter imageName:           图片
    /// - parameter target:              监听者
    /// - parameter action:              监听事件
    ///
    /// - returns: UIButton
    convenience init(backgroundImageName: String, imageName: String?, target: Any?, action: Selector) {
        self.init()
        // 设置背景图片
        self.setBackgroundImage(UIImage(named: backgroundImageName), for: UIControlState.normal)
        self.setBackgroundImage(UIImage(named: "\(backgroundImageName)_highlighted"), for: UIControlState.highlighted)
        // 设置图片
        self.setImage(UIImage(named: (imageName ?? "")), for: UIControlState.normal)
        self.setImage(UIImage(named: "\(imageName)_highlighted"), for: UIControlState.highlighted)
        self.sizeToFit()
        // 设置监听
        self.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
    }
    
    /// 创建 button 快捷方式
    ///
    /// - parameter setHighlightedImageName: 图片名字
    /// - parameter title:                   标题
    /// - parameter target:                  监听者
    /// - parameter action:                  监听事件
    ///
    /// - returns: UIButton
    convenience init(setHighlightedImageName: String? = nil, title: String? = nil, target: Any?, action: Selector) {
        self.init()
        self.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        if let img = setHighlightedImageName {
            self.setImage(UIImage(named: img), for: UIControlState.normal)
            self.setImage(UIImage(named: "\(img)_highlighted"), for: UIControlState.highlighted)
        }
        
        if let text = title {
            self.setTitle(text, for: UIControlState.normal)
            self.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            self.setTitleColor(MFTHEMECOLOR, for: UIControlState.highlighted)
            self.titleLabel?.font = UIFont.systemFont(ofSize: MFNormalFont)
        }
        self.sizeToFit()
    }
    
    /// 创建 button 快捷方式
    ///
    /// - parameter setBackgroundImageName: 背景图片名字
    /// - parameter title:                  文字
    /// - parameter target:                 监听者
    /// - parameter action:                 监听事件
    ///
    /// - returns: 创建背景图片普通和高亮状态一样的UIButton
    convenience init(setBackgroundImageName: String?, title: String? = nil, target: Any?, action: Selector) {
        self.init()
        
        self.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        if let img = setBackgroundImageName {
            self.setBackgroundImage(UIImage(named: img), for: UIControlState.normal)
            self.setBackgroundImage(UIImage(named: img), for: UIControlState.highlighted)
        }
        
        if let text = title {
            self.setTitle(text, for: UIControlState.normal)
            self.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            self.setTitleColor(MFTHEMECOLOR, for: UIControlState.highlighted)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        self.sizeToFit()
    }
    
}
