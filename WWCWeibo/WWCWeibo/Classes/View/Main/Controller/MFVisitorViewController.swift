//
//  MFVisitorViewController.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/23.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFVisitorViewController: UIViewController {

    // MARK: - 属性
    var tableView: UITableView = UITableView()
    
    override func loadView() {
        if !MFUserAccountViewModel.sharedTools.isLoagin {
            let visitorView = MFVisitorView()
            visitorView.closure = {
                self.btnClick()
            }
            view = visitorView
            // 设置访客状态下导航栏的item
            navigationItem.leftBarButtonItem = UIBarButtonItem(setHighlightedImageName: nil, title: "注册", target: self, action: #selector(btnClick))
            navigationItem.rightBarButtonItem = UIBarButtonItem(setHighlightedImageName: nil, title: "登录", target: self, action: #selector(btnClick))
            
            if self.isMember(of: MFHomeViewController.self) {
                return
            } else if self.isMember(of: MFMessageViewController.self) {
                visitorView.setupInfo(iconImageName: "visitordiscover_image_message", title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
            } else if self.isMember(of: MFDiscoverViewController.self) {
                visitorView.setupInfo(iconImageName: "visitordiscover_image_message", title: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
            } else {
                visitorView.setupInfo(iconImageName: "visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
            }
            
        } else {
            view = tableView
            view.backgroundColor = UIColor.white
        }
    }
    
    // MARK: - 监听方法
    func btnClick() {
        let OAuthVc = MFOAuthViewController()
        let nav = MFNavigationController(rootViewController: OAuthVc)
    	present(nav, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
}
