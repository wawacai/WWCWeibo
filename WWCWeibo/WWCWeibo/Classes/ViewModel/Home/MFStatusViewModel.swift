//
//  MFStatusViewModel.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/27.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFStatusViewModel: NSObject {
    
    // MARK: - 属性
    var statusModel: MFStatusModel? {
        didSet {
            mbrankImage = dealMbrankImage(mbrank: statusModel?.user?.mbrank ?? 0)
            verifiedImage = dealRerifiedImage(verified: statusModel?.user?.verified ?? -1)
            retweetContent = "@\(statusModel?.retweeted_status?.user?.name ?? "")：\(statusModel?.retweeted_status?.text ?? "")"
            
            repostsCountStr = dealCount(count: statusModel!.reposts_count, title: "转发")
            commentsCountStr = dealCount(count: statusModel!.comments_count, title: "评论")
            attitudesCountStr = dealCount(count: statusModel!.attitudes_count, title: "赞")
            
            dealSource(source: statusModel?.source ?? "")
        }
    }
    
    /// 会员等级图片
    var mbrankImage: UIImage?
    /// 认证等级图片
    var verifiedImage: UIImage?
    /// 转发微博内容
    var retweetContent: String?
    /// 转发数量的字符串
    var repostsCountStr: String?
    /// 评论数量的字符串
    var commentsCountStr: String?
    /// 赞数量的字符串
    var attitudesCountStr: String?
    /// 微博来源
    var sourceStr: String?
    //  时间格式化处理
    var timeStr: String?{
        guard let createdAt = statusModel?.created_at else {
            return nil
        }
        // 是否是今年
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "en_US")
        dt.dateFormat = "yyyy"
        // 获取当前年份
        let currentYear = dt.string(from: Date())
        // 获取发微博的年份
        let createdYear = dt.string(from: createdAt)
        // 判断是否是今年
        if createdYear == currentYear {
            let calender = Calendar.current
            // 判断是否是今天
            if calender.isDateInToday(createdAt) {
                let timeInterval = abs(createdAt.timeIntervalSinceNow)
                // 判断是否是1分钟之内
                if timeInterval <= 60 {
                    return "刚刚"
                } else if timeInterval <= 3600 {
                    let result = Int(timeInterval) / 60
                    return "\(result)分钟之前"
                } else {
                    let result = Int(timeInterval) / 3600
                    return "\(result)小时之前"
                }
            } else if calender.isDateInYesterday(createdAt) {
                // 表示是昨天
                dt.dateFormat = "昨天: HH:mm"
            } else {
                // 表示是其他时间
                dt.dateFormat = "MM-dd HH:mm"
            }
        } else {
            dt.dateFormat = "yyy-MM-dd HH:mm"
        }
        return dt.string(from: createdAt)
    }
}
// 判断 转发 评论 赞
extension MFStatusViewModel {
    func dealCount(count: Int, title: String) -> String? {
        if count <= 0 {
            return title
        }
        if  count < 10000 {
            return "\(count)"
        }
        let num = CGFloat(count/1000) / 10
        var str = "\(num)"
        if str.contains(".0") {
            str = str.replacingOccurrences(of: ".0", with: "")
        }
        return "\(str)万"
    }
}

extension MFStatusViewModel {
    // 会员等级图片处理
    func dealMbrankImage(mbrank: Int) -> UIImage? {
        if mbrank > 0 {
            return UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        return UIImage(named: "common_icon_membership_expired")
    }
    // 认证等级处理
    func dealRerifiedImage(verified: Int) -> UIImage? {
        switch verified {
        case 1:
            return UIImage(named: "avatar_vip")
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return UIImage(named: "avatar_vgirl")
        }
    }
    // 来源处理
    func dealSource(source: String) {
        if let startRange = source.range(of: "\">"), let endRange = source.range(of: "</") {
            // 开始光标位置
            let startIndex = startRange.upperBound
            // 结束光标位置
            let endIndex = endRange.lowerBound
            sourceStr = source.substring(with: startIndex..<endIndex)
        }
    }
}
