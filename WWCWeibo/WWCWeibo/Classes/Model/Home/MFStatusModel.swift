//
//  MFStatusModel.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/27.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFStatusModel: NSObject {
    /// 创建时间
    var created_at: Date?
	// 微博信息
    var text: String?
    // 微博来源
    var source:String?
    /// 微博ID
    var id: Int = 0
    // 被转发的原微博信息字段
    var retweeted_status: MFStatusModel?
    // 转发数
    var reposts_count: Int = 0
    // 评论数
    var comments_count: Int = 0
    // 表态数
    var attitudes_count: Int = 0
    // 微博作者的用户信息字段
    var user: MFUserModel?
    /// 配图数组
    var pic_urls: [MFPictureInfoModel]?
    
    // 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
    // 类方法 使用 class || static修饰
    class func modelContainerPropertyGenericClass() -> [String: Any] {
        return ["pic_urls": MFPictureInfoModel.self]
    }
}
