//
//  MFStatusBottomView.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/28.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFStatusBottomView: UIView {
    // MARK: - 属性
    var retweetButton: UIButton?
    var commentButton: UIButton?
    var unlikeButton: UIButton?
    var bottomViewModel: MFStatusViewModel? {
        didSet {
            retweetButton?.setTitle(bottomViewModel?.repostsCountStr, for: UIControlState.normal)
            commentButton?.setTitle(bottomViewModel?.commentsCountStr, for: UIControlState.normal)
            unlikeButton?.setTitle(bottomViewModel?.attitudesCountStr, for: UIControlState.normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	// MARK: - 搭建界面
    func setupUI() {
        // 添加控件
    	retweetButton = addButton(imageName: "timeline_icon_retweet", title: "转发")
        commentButton = addButton(imageName: "timeline_icon_comment", title: "评论")
        unlikeButton = addButton(imageName: "timeline_icon_unlike", title: "赞")
        let line1 = addLine()
        let line2 = addLine()
        
        // 约束
        retweetButton!.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(self)
            make.width.equalTo(commentButton!)
        }
        commentButton!.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(retweetButton!.snp.right)
            make.width.equalTo(unlikeButton!)
        }
        unlikeButton!.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(self)
            make.left.equalTo(commentButton!.snp.right)
        }
        line1.snp.makeConstraints { (make) in
            make.centerX.equalTo(retweetButton!.snp.right)
            make.centerY.equalTo(retweetButton!)
        }
        line2.snp.makeConstraints { (make) in
            make.centerX.equalTo(commentButton!.snp.right)
            make.centerY.equalTo(commentButton!)
        }
    }
    // 添加按钮的方法
    func addButton(imageName: String, title: String) -> UIButton {
        let btn = UIButton(setHighlightedImageName: imageName, title: title, target: self, action: #selector(btnClick))
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background_highlighted"), for: UIControlState.highlighted)
        addSubview(btn)
        return btn
    }
    
    func addLine() -> UIImageView {
        let imageV = UIImageView(imageName: "timeline_card_bottom_line")
        addSubview(imageV)
        return imageV
    }
    
    // MARK: - 监听事件
    func btnClick() {
        
    }
}
