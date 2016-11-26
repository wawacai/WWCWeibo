//
//  MFStatusRetweetView.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/27.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFStatusRetweetView: UIView {
    
    // MARK: - 属性
    var retweetViewModel: MFStatusViewModel? {
        didSet {
            contentLabel.text = retweetViewModel?.retweetContent
            
            bottomCons?.deactivate()
            if (retweetViewModel?.statusModel?.retweeted_status?.pic_urls?.count)! > 0 {
                pictureView.isHidden = false
                pictureView.picUrls = retweetViewModel?.statusModel?.retweeted_status?.pic_urls
                self.snp.makeConstraints({ (make) in
                    make.bottom.equalTo(pictureView).offset(10)
                })
            } else {
                pictureView.isHidden = true
                self.snp.makeConstraints({ (make) in
                    make.bottom.equalTo(contentLabel).offset(10)
                })
            }
        }
    }
    /// 文字内容
    lazy var contentLabel: UILabel = UILabel(text: "老婆最大，老婆最厉害，老婆最漂亮，老婆最好。老婆最大，老婆最厉害，老婆最漂亮，老婆最好。老婆最大，老婆最厉害，老婆最漂亮，老婆最好。老婆最大，老婆最厉害，老婆最漂亮，老婆最好。", fontSize: MFNormalFont, textColor: UIColor.darkGray, maxWidth: MFSCREENSIZEW - 20)
    /// 配图
    lazy var pictureView: MFStatusPictrueView = {
        let view = MFStatusPictrueView()
        view.backgroundColor = UIColor(white: 237/255, alpha: 1)
        return view
    }()
    /// 约束记录
    var bottomCons: Constraint?
	
    override init(frame: CGRect) {
        super.init(frame: frame)
    	setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor(white: 237/255, alpha: 1)
        // 添加控件
        addSubview(contentLabel)
        addSubview(pictureView)
        // 约束
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
        }
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.left.equalTo(contentLabel)
        }
        self.snp.makeConstraints { (make) in
            bottomCons = make.bottom.equalTo(pictureView).offset(10).constraint
        }
    }

}
