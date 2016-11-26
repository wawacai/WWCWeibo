//
//  MFStatusCell.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/27.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFStatusCell: UITableViewCell {
    
    // MARK: - 属性
    var statusViewModel: MFStatusViewModel? {
        didSet {
            originalView.originalViewModel = statusViewModel
            bottomView.bottomViewModel = statusViewModel
			// 卸载底部视图顶部约束，判断是否有转发微博
            bottomViewCons?.deactivate()
            if statusViewModel?.statusModel?.retweeted_status == nil {
                retweetView.isHidden = true
                bottomView.snp.makeConstraints({ (make) in
                    bottomViewCons = make.top.equalTo(originalView.snp.bottom).constraint
                })
            } else {
                retweetView.isHidden = false
                retweetView.retweetViewModel = statusViewModel
                bottomView.snp.makeConstraints({ (make) in
                    bottomViewCons = make.top.equalTo(retweetView.snp.bottom).constraint
                })
            }
        }
    }
    /// 原生微博
    var originalView: MFStatusOriginalView = MFStatusOriginalView()
    /// 转发微博
    var retweetView: MFStatusRetweetView = MFStatusRetweetView()
    /// 底部视图
    var bottomView: MFStatusBottomView = MFStatusBottomView()
    /// 底部视图top约束
    var bottomViewCons: Constraint?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 搭建界面
    func setupUI() {
        backgroundColor = UIColor(white: 237/255, alpha: 1)
//        backgroundColor = randomColor()
        // 添加控件
        contentView.addSubview(originalView)
        contentView.addSubview(retweetView)
        contentView.addSubview(bottomView)
        
        // 设置约束
        originalView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.contentView)
        }
        retweetView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(originalView.snp.bottom)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.contentView)
            bottomViewCons = make.top.equalTo(retweetView.snp.bottom).constraint
            make.bottom.equalTo(self.contentView).offset(-8)
        }
    }

}
