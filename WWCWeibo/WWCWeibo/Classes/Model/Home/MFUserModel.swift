//
//  MFUserModel.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/27.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFUserModel: NSObject {
    /// 用户UID
    var id: Int = 0
    /// 友好显示名称
    var name: String?
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    /// 认证类型 -1：没有认证，1，认证用户，2,3,5: 企业认证，220: 达人
    var verified: Int = -1
    /// 会员等级 1-6
    var mbrank: Int = 0
}
