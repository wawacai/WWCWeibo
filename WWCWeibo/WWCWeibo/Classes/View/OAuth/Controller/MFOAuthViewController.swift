//
//  MFOAuthViewController.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/24.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit
import YYModel

class MFOAuthViewController: UIViewController {

    // MARK: - 属性
    // webView
    private lazy var webView: UIWebView = {
        let v = UIWebView()
        v.delegate = self
        let url = URL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(MFCLIENTID)&redirect_uri=\(MFREDIRECTURI)")
        let request = URLRequest(url: url!)
        v.loadRequest(request)
        return v
    }()
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setupUI()
    }

    private func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(setHighlightedImageName: nil, title: "取消", target: self, action: #selector(cancleBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(setHighlightedImageName: nil, title: "自动填充", target: self, action: #selector(autoFillData))
        navigationItem.title = "微博登录"
    }
    
    // MARK: - 监听事件
    func cancleBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func autoFillData() {
        let jsString = "document.getElementById('userId').value='\(MFWBNAME)',document.getElementById('passwd').value='\(MFWBPASSWD)'"
        // js注入
        webView.stringByEvaluatingJavaScript(from: jsString)
    }
}
// MARK: - 代理方法
extension MFOAuthViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.url?.absoluteString
        
        if let u = urlString, u.hasPrefix(MFREDIRECTURI) {
            let query = request.url?.query
            if let q = query {
                let code = q.substring(from: "code=".endIndex)
                MFUserAccountViewModel.sharedTools.loadAcessToken(code: code, finish: { (isSuccess) in
                    if !isSuccess {
                        print("请求失败")
                        return
                    }
                    print("请求成功")
                    self.dismiss(animated: false, completion: {
                        // 获得用户数据后，发出通知，切换根控制器到欢迎控制器
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MFSwitchRootVc), object: nil)
                    })
                })
                // 如果成功就不再加载
                return false
            }
        }
        return true
    }
}







