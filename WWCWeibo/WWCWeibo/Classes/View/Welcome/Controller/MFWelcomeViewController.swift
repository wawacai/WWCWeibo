//
//  MFWelcomeViewController.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/27.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit
import SDWebImage

class MFWelcomeViewController: UIViewController {

    override func loadView() {
        view = imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        setupUI()
        
    }
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 修改约束
        headImageView.snp.updateConstraints { (make) in
            make.top.equalTo(view).offset(0.15 * MFSCREENSIZEH)
        }
        // 设置动画
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.view.layoutIfNeeded()
            }) { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.messageLabel.alpha = 1
                    }, completion: { (_) in
                        // 动画结束后发出通知，切换根控制器到main控制器
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MFSwitchRootVc), object: "welcomeVc")
                })
        }
    }
    
    // 搭建界面
    func setupUI() {
        // 增加控件
        view.addSubview(headImageView)
        view.addSubview(messageLabel)
        
        // 设置约束
        headImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 90, height: 90))
            make.top.equalTo(view).offset(0.6 * MFSCREENSIZEH)
        }
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headImageView.snp.bottom).offset(16)
            make.centerX.equalTo(view)
        }
    }
    // MARK: - 懒加载控件
    // 背景图片
    private lazy var imageView: UIImageView = {
       let imageV = UIImageView(image: UIImage(named: "ad_background"))
        imageV.frame = UIScreen.main.bounds
        return imageV
    }()
    // 头像
    private lazy var headImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.mf_setImage(withURLString: MFUserAccountViewModel.sharedTools.userAccountModel?.avatar_large, placeholderImageName: "avatar_default")
        imageV.layer.borderColor = MFTHEMECOLOR.cgColor
        imageV.layer.borderWidth = 1
        imageV.layer.cornerRadius = 45
        imageV.layer.masksToBounds = true
        return imageV
    }()
	// 文字
    private lazy var messageLabel: UILabel = {
       let message = UILabel(text: "欢迎回来", fontSize: MFNormalFont, textColor: MFTHEMECOLOR)
        message.alpha = 0
        message.textAlignment = .center
        return message
    }()
}
