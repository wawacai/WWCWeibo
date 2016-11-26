//
//  MFUserAccountViewModel.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/26.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFUserAccountViewModel {
	// 全局访问点
    static var sharedTools: MFUserAccountViewModel = MFUserAccountViewModel()
    // 模型属性
    var userAccountModel: MFUserAccountModel?
    // 路径
    let filePath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString).appendingPathComponent("userAccount.archiver")
    // 判断用户是否登录
    var isLoagin: Bool {
        return access_token != nil
    }
    
    var access_token: String? {
        if userAccountModel == nil {
            return nil
        }else {
            if userAccountModel?.expires_Date?.compare(Date()) == ComparisonResult.orderedAscending {
                return nil
            } else {
                return userAccountModel!.access_token!
            }
        }
    }
    
     init() {
        userAccountModel = getUserAccountModel()
    }
}
// MARK: - 帮助控制器请求数据
extension MFUserAccountViewModel {
    // 获取token
    func loadAcessToken(code: String, finish: @escaping (Bool)->()) {
        MFNetworkingTool.sharedTool.oathLoadUserAccount(code: code, success: { (response) in
            // 判断返回值是否为nil，是否能转成字典
            guard let res = response as? [String:Any] else {
                finish(false)
                return
            }
            
            let userAccountModel = MFUserAccountModel.yy_model(withJSON: res)
            // 判断模型是否为nil
            guard let model = userAccountModel else {
                finish(false)
                return
            }
            self.getUserInfo(model: model, finish: finish)
            
            }) { (error) in
                print(error)
                finish(false)
        }
    }
    // 获取用户信息
    func getUserInfo(model: MFUserAccountModel, finish: @escaping (Bool)->()) {
        MFNetworkingTool.sharedTool.oathgetUserInfo(model: model, success: { (response) in
            // 判断返回值是否为nil，是否能转成字典
            guard let res = response as? [String:Any] else {
                finish(false)
                return
            }
            // 手动给模型属性赋值
            model.setValue(res["screen_name"], forKey: "screen_name")
            model.setValue(res["avatar_large"], forKey: "avatar_large")
            // 归档
            self.saveUserAccountModel(model: model)
            finish(true)
            
            }) { (error) in
                print(error)
                finish(false)
        }
    }
}

// MARK: - 归档和解档
extension MFUserAccountViewModel {
    // 归档
    func saveUserAccountModel(model: MFUserAccountModel) {
        userAccountModel = model
        NSKeyedArchiver.archiveRootObject(model, toFile: filePath)
    }
    // 解档
    func getUserAccountModel() -> MFUserAccountModel? {
       return NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? MFUserAccountModel
    }
}
