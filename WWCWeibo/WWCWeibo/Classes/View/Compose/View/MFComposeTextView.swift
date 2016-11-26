//
//  MFComposeTextView.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/11/3.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFComposeTextView: UITextView {
    // 占位字
    private lazy var placeHolderLabel: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.textColor = UIColor.lightGray
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    // 给外界传入占位字符的接口
    var placeHolder: String? {
        didSet {
            placeHolderLabel.text = placeHolder
        }
    }
    // 重写字符大小的属性
    override var font: UIFont? {
        didSet {
            if font != nil {
                placeHolderLabel.font = font
            }
        }
    }
    
    // 富文本拼接成字符串
    var emoticonStr: String? {
        var result = ""
        
        self.attributedText.enumerateAttributes(in: NSMakeRange(0, self.attributedText.length), options: []) { (info, range, _) in
            if let attchment = info["NSAttachment"] as? MFTextAttachment {
                // 表示为图片
                result += (attchment.emotionModel?.chs)!
            } else {
                // 是文本
               result += attributedText.attributedSubstring(from: range).string
            }
        }
        return result
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 搭建界面
    private func setupUI() {
        // 添加控件
        addSubview(placeHolderLabel)
        // 设置约束
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 6))
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -10))
        
        // 监听通知
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    // 监听事件
     @objc private func textChange() {
        placeHolderLabel.isHidden = hasText
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
