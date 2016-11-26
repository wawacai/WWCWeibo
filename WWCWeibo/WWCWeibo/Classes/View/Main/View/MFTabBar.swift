//
//  MFTabBar.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/22.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFTabBar: UITabBar {
    // 定义一个闭包
    var callback: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var index: CGFloat = 0
        for value in subviews {
            if value.isKind(of: NSClassFromString("UITabBarButton")!) {
                value.frame.origin.x = MFSCREENSIZEW * 0.2 * index
                value.frame.size.width = MFSCREENSIZEW * 0.2
                index += 1
            }
            if index == 2 {
                index += 1
            }
        }
        // 设置撰写按钮的位置
        composeBtn.center.x = MFSCREENSIZEW * 0.5
        composeBtn.center.y = frame.size.height * 0.5
    }
    
    // MARK: - 监听事件
    @objc private func btnClick() {
        callback?()
    }
    
    // MARK: - 搭建界面
    func setupUI() {
        addSubview(composeBtn)
    }
    
    // MARK: - 创建懒加载控件
    lazy var composeBtn: UIButton = {
        let btn = UIButton(backgroundImageName: "tabbar_compose_button", imageName: "tabbar_compose_icon_add", target: self, action: #selector(btnClick))
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
