//
//  MFStatusOriginalView.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/27.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFStatusOriginalView: UIView {
    // MARK: - 属性
    /// 模型
    var originalViewModel: MFStatusViewModel? {
        didSet {
            headImageView.mf_setImage(withURLString: originalViewModel?.statusModel?.user?.profile_image_url, placeholderImageName: "avatar_default")
            nameLabel.text = originalViewModel?.statusModel?.user?.name ?? ""
            membershipImageView.image = originalViewModel?.mbrankImage
            avatarImageView.image = originalViewModel?.verifiedImage
            textLabel.text = originalViewModel?.statusModel?.text
            sourceLabel.text = originalViewModel?.sourceStr
            timeLabel.text = originalViewModel?.timeStr
            
            // 判断是否有配图
            bottomCons?.deactivate()
            if (originalViewModel?.statusModel?.pic_urls?.count)! > 0 {
                pictureView.isHidden = false
                pictureView.picUrls = originalViewModel?.statusModel?.pic_urls
                self.snp.makeConstraints({ (make) in
                    bottomCons = make.bottom.equalTo(pictureView).offset(10).constraint
                })
            } else {
                pictureView.isHidden = true
                self.snp.makeConstraints({ (make) in
                    bottomCons = make.bottom.equalTo(textLabel).offset(10).constraint
                })
            }
        }
    }
    /// 头像
    lazy var headImageView: UIImageView = UIImageView(imageName: "avatar_default")
    /// 昵称
    lazy var nameLabel: UILabel = UILabel(text: "大宝贝", fontSize: MFNormalFont, textColor: UIColor.blue)
    /// 微博等级
    lazy var membershipImageView: UIImageView = UIImageView(imageName: "common_icon_membership")
    /// 时间
    lazy var timeLabel: UILabel = UILabel(text: "6分钟前", fontSize: MFSmallFont, textColor: MFTHEMECOLOR)
    /// 来源
    lazy var sourceLabel: UILabel = UILabel(text: "娃娃菜的微博", fontSize: MFSmallFont, textColor: UIColor.lightGray)
    /// 认证等级
    lazy var avatarImageView: UIImageView = UIImageView(imageName: "avatar_vgirl")
    /// 原创微博内容
    lazy var textLabel: UILabel = UILabel(text: "老婆最大，老婆最厉害，老婆最漂亮，老婆最好。老婆最大，老婆最厉害，老婆最漂亮，老婆最好。老婆最大，老婆最厉害，老婆最漂亮，老婆最好。老婆最大，老婆最厉害，老婆最漂亮，老婆最好。", fontSize: MFNormalFont, textColor: UIColor.darkGray, maxWidth: MFSCREENSIZEW - 20)
    /// 配图
    lazy var pictureView: MFStatusPictrueView = {
        let view = MFStatusPictrueView()
        view.backgroundColor = self.backgroundColor
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
        backgroundColor = UIColor.white
        // 添加控件
        addSubview(headImageView)
        addSubview(nameLabel)
        addSubview(membershipImageView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(avatarImageView)
        addSubview(textLabel)
        addSubview(pictureView)
        
        // 约束
        headImageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(10)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headImageView)
            make.left.equalTo(headImageView.snp.right).offset(10)
        }
        
        membershipImageView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(10)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(headImageView)
            make.left.equalTo(nameLabel)
        }
        
        sourceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel)
            make.left.equalTo(timeLabel.snp.right).offset(10)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(headImageView.snp.bottom)
            make.centerX.equalTo(headImageView.snp.right)
        }
        
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView)
            make.top.equalTo(headImageView.snp.bottom).offset(10)
        }
        
        pictureView.snp.makeConstraints { (make) in
            make.left.equalTo(textLabel)
            make.top.equalTo(textLabel.snp.bottom).offset(10)
        }
        
        self.snp.makeConstraints { (make) in
            bottomCons = make.bottom.equalTo(pictureView).offset(10).constraint
        }
    }

}


