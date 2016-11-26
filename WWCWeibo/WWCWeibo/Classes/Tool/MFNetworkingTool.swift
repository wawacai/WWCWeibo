//
//  MFNetworkingTool.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/24.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit
import AFNetworking

enum MFRequestMethod: String {
    case get = "get"
    case post = "post"
}
class MFNetworkingTool: AFHTTPSessionManager {

    static let sharedTool: MFNetworkingTool = {
       var tool = MFNetworkingTool()
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tool
    }()
    
    /// 封装的网络请求方法
    ///
    /// - parameter method:     请求方法
    /// - parameter URLString:  URL
    /// - parameter parameters: 参数
    /// - parameter success:    成功回调
    /// - parameter failure:    失败回调
    func request(method: MFRequestMethod, URLString: String, parameters: Any?, success: @escaping (Any?)->(), failure: @escaping (Error)->()) {
        if method == .get {
            get(URLString, parameters: parameters, progress: nil, success: { (_, responseObject) in
                success(responseObject)
                }, failure: { (_, error) in
                    failure(error)
            })
            
        } else {
            post(URLString, parameters: parameters, progress: nil, success: { (_, responseObject) in
                success(responseObject)
                }, failure: { (_, error) in
                    failure(error)
            })
        }
    }
    
}

// MARK: - 发微博相关接口
extension MFNetworkingTool {
    // 发送文字微博
    func update(status: String, success: @escaping (Any?)->(), failure: @escaping (Error)->()) {
        let URLString = "https://api.weibo.com/2/statuses/update.json"
        let parame = [
            "access_token": MFUserAccountViewModel.sharedTools.userAccountModel?.access_token ?? "",
            "status": status
        ]
        MFNetworkingTool.sharedTool.request(method: .post, URLString: URLString, parameters: parame, success: success, failure: failure)
    }
    // 发送带图片的微博
    func upload(status: String, picture: UIImage, success: @escaping (Any?)->(), failure: @escaping (Error)->()) {
        let URLString = "https://upload.api.weibo.com/2/statuses/upload.json"
        let parame = [
            "access_token": MFUserAccountViewModel.sharedTools.userAccountModel?.access_token ?? "",
            "status": status
        ]
        // 图片转成二进制
        let imageData = UIImageJPEGRepresentation(picture, 0.7)
        post(URLString, parameters: parame, constructingBodyWith: { (formData) in
            formData.appendPart(withFileData: imageData!, name: "pic", fileName: "test", mimeType: "image/png")
        }, progress: nil, success: { (_, response) in
            success(response)
        }) { (_, error) in
            failure(error)
        }
    }
}

// MARK: - 首页相关的接口
extension MFNetworkingTool {
    func homeLoadData(sinceId: Int64, maxId: Int64, success: @escaping (Any?)->(), failure: @escaping (Error)->()) {
        let URLString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let parame = [
            "access_token" : MFUserAccountViewModel.sharedTools.userAccountModel?.access_token ?? "",
            "since_id" : sinceId,
            "max_id" : maxId
        ] as [String : Any]
        MFNetworkingTool.sharedTool.request(method: MFRequestMethod.get, URLString: URLString, parameters: parame, success: success, failure: failure)
    }
}

// MARK: - OAuth 授权相关接口
extension MFNetworkingTool {
    // 获取用户的userAccount
    func oathLoadUserAccount(code: String, success: @escaping (Any?)->(), failure: @escaping (Error)->()) {
        let URLString = "https://api.weibo.com/oauth2/access_token"
        let parame = [
            "client_id" : MFCLIENTID,
            "client_secret" : MFCLIENTSECRET,
            "grant_type" : "authorization_code",
            "code" : code,
            "redirect_uri" : MFREDIRECTURI
        ]
        MFNetworkingTool.sharedTool.request(method: MFRequestMethod.post, URLString: URLString, parameters: parame, success: success, failure: failure)
	}
	// 获取用户信息
    func oathgetUserInfo(model: MFUserAccountModel, success: @escaping (Any?)->(), failure: @escaping (Error)->()) {
        let URLString = "https://api.weibo.com/2/users/show.json"
        let parame = [
            "access_token" : model.access_token!,
            "uid" : model.uid!
        ]
        MFNetworkingTool.sharedTool.request(method: MFRequestMethod.get, URLString: URLString, parameters: parame, success: success, failure: failure)
    }
}



