//
//  MFComposeButton.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/11/2.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFComposeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 搭建界面
    private func setupUI() {
        imageView?.contentMode = .center
        titleLabel?.textAlignment = .center
        setTitleColor(UIColor.darkGray, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    // 取消高亮效果
    override var isHighlighted: Bool {
        get {
            return false
        }
        set {
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置图片的位置
        imageView?.frame.size.width = self.frame.size.width
        imageView?.frame.size.height = self.frame.size.width
        imageView?.frame.origin.x = 0
        imageView?.frame.origin.y = 0
        // 设置文字的位置
        titleLabel?.frame.size.width = self.frame.size.width
        titleLabel?.frame.size.height = self.frame.size.height - self.frame.size.width
        titleLabel?.frame.origin.x = 0
        titleLabel?.frame.origin.y = self.frame.size.width
    }

}
