//
//  MFVisitorView.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/23.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFVisitorView: UIView {
    
    // MARK: - 懒加载属性
    // 圆圈图
    lazy var cycleImageView: UIImageView = {
        let c = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return c
    }()
    // 蒙版
    lazy var maskImageView: UIImageView = {
        let m = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return m
    }()
    // 房子
    lazy var iconImageView: UIImageView = {
        let h = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return h
    }()
    // 描述
    lazy var descText: UILabel = {
       let d = UILabel(text: "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜", fontSize: MFNormalFont, textColor: UIColor.darkGray)
        d.textAlignment = .center
        return d
    }()
    // 登录按钮
    lazy var loginBtn: UIButton = {
        let l = UIButton(setBackgroundImageName: "common_button_white", title: "登录", target: self, action: #selector(loginBtnClick))
        return l
    }()
    // 注册按钮
    lazy var registerBtn: UIButton = {
        let l = UIButton(setBackgroundImageName: "common_button_white", title: "注册", target: self, action: #selector(loginBtnClick))
        return l
    }()
    // 闭包
    var closure: (()->())?
    
    // MARK: - 监听事件
    func loginBtnClick() {
        closure?()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置背景颜色
        backgroundColor = UIColor(white: 235/255, alpha: 1)
        setupUI()
    }
    // 搭建界面
    private func setupUI() {
        
        // 添加控件
        addSubview(cycleImageView)
        addSubview(maskImageView)
        addSubview(iconImageView)
        addSubview(descText)
        addSubview(loginBtn)
        addSubview(registerBtn)
        // 动画
        cycleImageViewAnim()
        
        // 设置约束
        cycleImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        maskImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        descText.snp.makeConstraints { (make) in
            make.width.equalTo(230)
            make.top.equalTo(maskImageView.snp.bottom).offset(16)
            make.centerX.equalTo(self)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.left.equalTo(descText)
            make.top.equalTo(descText.snp.bottom).offset(16)
            make.size.equalTo(CGSize(width: 100, height: 35))
        }
        
        registerBtn.snp.makeConstraints { (make) in
            make.right.equalTo(descText)
            make.top.equalTo(descText.snp.bottom).offset(16)
            make.size.equalTo(CGSize(width: 100, height: 35))
        }
    }
    
    func cycleImageViewAnim() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = M_PI * 2
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        cycleImageView.layer.add(anim, forKey: nil)
    }
    
    // 如果是其他的页面就重新设置图片和标题
    func setupInfo(iconImageName: String, title: String) {
            cycleImageView.removeFromSuperview()
            iconImageView.image = UIImage(named: iconImageName)
            descText.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
