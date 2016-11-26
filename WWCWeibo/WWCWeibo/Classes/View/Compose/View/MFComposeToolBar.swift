//
//  MFComposeToolBar.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/11/3.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

enum ToolBarButtonType: Int {
    case camera = 0
    case mention = 1
    case trend = 2
    case emoticon = 3
    case add = 4
}
class MFComposeToolBar: UIStackView {
    
    // 回调闭包
    var callBack: ((ToolBarButtonType)->())?
    // 表情按钮
    var emoticonBtn: UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 搭建界面
    private func setupUI() {
        // 布局方向
        axis = .horizontal
        // 填充模式
        distribution = .fillEqually
        
        addBtn(imageName: "compose_camerabutton_background", type: .camera)
        addBtn(imageName: "compose_mentionbutton_background", type: .mention)
        addBtn(imageName: "compose_trendbutton_background", type: .trend)
        emoticonBtn = addBtn(imageName: "compose_emoticonbutton_background", type: .emoticon)
        addBtn(imageName: "compose_add_background", type: .add)
    }
    @discardableResult // 忽略方法的返回值
    private func addBtn(imageName: String, type: ToolBarButtonType) -> UIButton {
        let btn = UIButton()
        btn.tag = type.rawValue
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named: "compose_toolbar_background"), for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        addArrangedSubview(btn)
        return btn
    }
    
    @objc private func btnClick(btn: UIButton) {
        let type = ToolBarButtonType(rawValue: btn.tag)
        callBack?(type!)
    }
    
    func showIcon(isEmoticon: Bool) {
        if isEmoticon {
            emoticonBtn?.setImage(UIImage(named: "compose_keyboardbutton_background"), for: .normal)
            emoticonBtn?.setImage(UIImage(named: "compose_keyboardbutton_background_highlighted"), for: .highlighted)
        } else {
            emoticonBtn?.setImage(UIImage(named: "compose_emoticonbutton_background"), for: .normal)
            emoticonBtn?.setImage(UIImage(named: "compose_emoticonbutton_background_highlighted"), for: .highlighted)
        }
    }

}
