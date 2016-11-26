//
//  MFStatusListViewModel.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/27.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit
import YYModel
import SDWebImage

class MFStatusListViewModel: NSObject {
    // MARK: - 属性
    var statusDataArr: [MFStatusViewModel] = [MFStatusViewModel]()
    // 返回ID比since_id大的微博
    var sinceId: Int64 = 0
    // 返回ID小于或等于max_id的微博
    var maxId: Int64 = 0
	
    // MARK: - 请求数据
    func getHomeData(isPullup: Bool, finish: @escaping (Bool, String)->()) {
        // 判断是否是上拉刷新，设定 sinceId maxId
        if isPullup {
            sinceId = 0
            maxId = Int64(statusDataArr.last?.statusModel?.id ?? 0)
            maxId -= 1
        } else {
            sinceId = Int64(statusDataArr.first?.statusModel?.id ?? 0)
            maxId = 0
        }
        
        let message = "加载失败"
        
        MFNetworkingTool.sharedTool.homeLoadData(sinceId: sinceId, maxId: maxId, success: { (response) in
            // 判断获得的数据是否为空并且是否能转为字典
            guard let resDict = response as? [String:Any] else {
                finish(false, message)
                return
            }
            // 判断statuses对应的value是否有值
            guard let statuses = resDict["statuses"] as? [[String:Any]] else {
                finish(false, message)
                return
            }
            let dataArr = NSArray.yy_modelArray(with: MFStatusModel.self, json: statuses) as! [MFStatusModel]
            var tempArr = [MFStatusViewModel]()
            for model in dataArr {
                let statusViewModel = MFStatusViewModel()
                statusViewModel.statusModel = model
                tempArr.append(statusViewModel)
            }
            if isPullup {
                self.statusDataArr = self.statusDataArr + tempArr
            } else {
                self.statusDataArr = tempArr + self.statusDataArr
            }
            self.singleImageDownload(array: tempArr, finish: finish)
            }) { (error) in
                print(error)
                finish(false, message)
        }
    }
    // 下载单张图片
    func singleImageDownload(array: [MFStatusViewModel], finish: @escaping (Bool, String)->()) {
        
        let group = DispatchGroup()
        
        for temp in array {
            if temp.statusModel?.pic_urls?.count == 1 {
                let url = URL(string: (temp.statusModel?.pic_urls?.last?.thumbnail_pic)!)
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (_, error, _, _, _) in
                    if error != nil {
                        print(error)
                    }
                    group.leave()
                })
            }
            if temp.statusModel?.retweeted_status?.pic_urls?.count == 1 {
                let url = URL(string: (temp.statusModel?.retweeted_status?.pic_urls?.last?.thumbnail_pic)!)
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (_, error, _, _, _) in
                    if error != nil {
                        print(error)
                    }
                    group.leave()
                })
            }    
        }
        group.notify(queue: DispatchQueue.main, execute: {
            var message = "现在已是最新消息"
            if array.count > 0 {
                message = "加载了\(array.count)条信息"
            }
            print("单张图片下载完毕")
            finish(true, message)
        })
    }
}
