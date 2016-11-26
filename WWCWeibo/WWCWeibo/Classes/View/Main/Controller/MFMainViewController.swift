//
//  MFMainViewController.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/22.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit
import SVProgressHUD

class MFMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabbar = MFTabBar()
        tabbar.callback = {
            if !MFUserAccountViewModel.sharedTools.isLoagin {
                SVProgressHUD.showError(withStatus: "请登录")
            }
            let composeView = MFComposeView()
            composeView.show(target: self)
        }
        setValue(tabbar, forKey: "tabBar")
        setupUI()  
    }
    
	// MARK: - 创建视图
    func setupUI() {
        // 创建tabbar的子控制器
        addChildViewController(vc: MFHomeViewController(), title: "首页", imageName: "tabbar_home")
		addChildViewController(vc: MFMessageViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(vc: MFDiscoverViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(vc: MFProfileViewController(), title: "我", imageName: "tabbar_profile")
    }
    
    // 创建控制器的方法
    func addChildViewController(vc: UIViewController, title: String, imageName: String) {
        // 设置导航栏和标签栏的标题
    	vc.title = title
        // 设置选中的字体颜色
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : MFTHEMECOLOR], for: UIControlState.selected)
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "\(imageName)_selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let nav = MFNavigationController(rootViewController: vc)
        addChildViewController(nav)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
