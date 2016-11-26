//
//  CommonTools.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/22.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

// 删除按钮通知名
let MFEmoticonDeleteButtonNotification = "MFEmoticonDeleteButtonNotification"

// 表情按钮通知名
let MFEmoticonButtonNotification = "MFEmoticonButtonNotification"

// 切换根控制器的通知名字
let MFSwitchRootVc = "MFSwitchRootVc"

// 微博的账号和密码
let MFWBNAME = "jubeisi0516873@163.com"
let MFWBPASSWD = "958794"

// 主题颜色
let MFTHEMECOLOR = UIColor.orange
// 屏幕的高和宽
let MFSCREENSIZEW = UIScreen.main.bounds.size.width
let MFSCREENSIZEH = UIScreen.main.bounds.size.height

// 字体大小
let MFBigFont: CGFloat = 18
let MFNormalFont: CGFloat = 14
let MFSmallFont: CGFloat = 10

// 申请应用时分配的AppKey
let MFCLIENTID = "807655454"
// 授权回调地址
let MFREDIRECTURI = "http://www.baidu.com"
// 申请应用时分配的AppSecret
let MFCLIENTSECRET = "299d0639437f607f97c37e624947bffa"

// 随机颜色
func randomColor() -> UIColor {
    let r = CGFloat(arc4random()%256)
    let g = CGFloat(arc4random()%256)
    let b = CGFloat(arc4random()%256)
    return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
}
