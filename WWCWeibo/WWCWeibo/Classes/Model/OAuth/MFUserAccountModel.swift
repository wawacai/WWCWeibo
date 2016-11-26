//
//  MFUserAccountModel.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/25.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFUserAccountModel: NSObject, NSCoding {
	/// 用户授权的唯一票据
    var access_token: String?
    /// access_token的生命周期，单位是秒数
    var expires_in: TimeInterval = 0{
        didSet{
            expires_Date = Date().addingTimeInterval(expires_in)
        }
    }
    /// 授权用户的UID
    var uid: String?
    /// 用户昵称
    var screen_name: String?
    /// 用户头像地址（大图）
    var avatar_large: String?
    /// 过期时间
    var expires_Date: Date?
    
    override init() {
        super.init()
    }
    
    // 归档
    func encode(with aCoder: NSCoder) {
        self.yy_modelEncode(with: aCoder)
    }
    // 解档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.yy_modelInit(with: aDecoder)
    }
    override var description: String {
        let keys = ["access_token","expires_in","uid"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
