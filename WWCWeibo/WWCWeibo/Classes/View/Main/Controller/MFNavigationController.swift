//
//  MFNavigationController.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/22.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		// 自定义导航的返回按钮后 屏幕左侧边缘右滑动的时候失效，解决办法如下
        interactivePopGestureRecognizer?.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 设置左侧item的标题
        var title: String
        if childViewControllers.count > 0 {
            title = "返回"
            if childViewControllers.count == 1 {
                title = childViewControllers.first?.title ?? ""
            }
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(setHighlightedImageName: "navigationbar_back_withtext", title: title, target: self, action: #selector(backBtnClick))
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    // 判断手势是否能够使用
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return childViewControllers.count != 1
    }
    
    // MARK: - 监听事件
    func backBtnClick() {
        popViewController(animated: true)
    }
}
