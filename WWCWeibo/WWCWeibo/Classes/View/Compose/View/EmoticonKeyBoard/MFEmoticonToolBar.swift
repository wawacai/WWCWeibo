//
//  MFEmoticonToolBar.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/11/4.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

// 按钮的类型枚举
enum MFEmoticonToolBarBtnType: Int {
    case latelyEmoticon = 0
    case defaultEmoticon = 1
    case emojiEmoticon = 2
    case lxhEmoticon = 3
}
class MFEmoticonToolBar: UIStackView {
    
    // MARK: - 懒加载控件
    // 记录上一次点击的按钮
    var lastSelectedBtn: UIButton?
    
    // 点击按钮的回调闭包
    var callBack: ((MFEmoticonToolBarBtnType)->())?
    
    // 存储按钮的数组
    var btnArr: [UIButton] = [UIButton]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 搭建界面
    private func setupUI() {
    	// 设置布局
        axis = .horizontal
        distribution = .fillEqually
        
        addBtn(imageName: "compose_emotion_table_left", title: "最近", type: .latelyEmoticon)
        addBtn(imageName: "compose_emotion_table_mid", title: "默认", type: .defaultEmoticon)
        addBtn(imageName: "compose_emotion_table_mid", title: "Emoji", type: .emojiEmoticon)
        addBtn(imageName: "compose_emotion_table_right", title: "浪小花", type: .lxhEmoticon)
        
    }
    // 添加按钮
    private func addBtn(imageName: String, title: String, type: MFEmoticonToolBarBtnType) {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: imageName + "_normal"), for: .normal)
        btn.setBackgroundImage(UIImage(named: imageName + "_selected"), for: .selected)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.tag = type.rawValue
        btnArr.append(btn)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        if type == .defaultEmoticon {
            lastSelectedBtn?.isSelected = false
            btn.isSelected = true
            lastSelectedBtn = btn
        }
        // 取消高亮效果
        btn.adjustsImageWhenHighlighted = false
        addArrangedSubview(btn)
    }
    // MARK: - 监听事件
    @objc private func btnClick(btn: UIButton) {
        lastSelectedBtn?.isSelected = false
        btn.isSelected = true
        lastSelectedBtn = btn
        let btnType = MFEmoticonToolBarBtnType(rawValue: btn.tag)!
        callBack?(btnType)
    }
    // 处理滚动过程中按钮状态的方法
    func selectedBtn(section: Int) {
        let btn = btnArr[section]
        if lastSelectedBtn == btn {
            return
        }
        lastSelectedBtn?.isSelected = false
        btn.isSelected = true
        lastSelectedBtn = btn
    }

}
