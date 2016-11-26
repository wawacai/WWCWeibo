//
//  MFHomeViewController.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/22.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

let statusCellID = "statusCellID"
class MFHomeViewController: MFVisitorViewController {
    
    // MARK: - 属性
    // viewModel
    let statusListViewModel: MFStatusListViewModel = MFStatusListViewModel()
    // 下拉刷新控件
    fileprivate lazy var refresh: MFRefreshControl = MFRefreshControl()
    // 上拉刷新控件
    fileprivate lazy var bottomRefreshView: UIActivityIndicatorView = {
       let b = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        b.color = UIColor.red
        return b
    }()
    // 提示动画
    var tipLabel: UILabel = {
       let tip = UILabel()
        tip.textAlignment = .center
        tip.font = UIFont.systemFont(ofSize: 12)
        tip.text = "没有最新信息"
        tip.backgroundColor = MFTHEMECOLOR
        tip.isHidden = true
        return tip
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
	// MARK: - 搭建界面
    func setupUI() {
        if !MFUserAccountViewModel.sharedTools.isLoagin {
            return
        }

        setupNav()
        getStatusData()
        setupTableViewInfo()
    }
    
    func setupNav() {
        // 右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(setHighlightedImageName: "navigationbar_friendsearch", title: nil, target: self, action: #selector(rightBtnClikc))
        // 左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(setHighlightedImageName: "navigationbar_pop", title: nil, target: self, action: #selector(leftBtnClikc))
        
        if let nav = self.navigationController {
            nav.view.insertSubview(tipLabel, belowSubview: nav.navigationBar)
            tipLabel.frame = CGRect(x: 0, y: nav.navigationBar.frame.maxY - 35, width: nav.navigationBar.bounds.size.width, height: 35)
        }
    }
    
    func setupTableViewInfo() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MFStatusCell.self, forCellReuseIdentifier: statusCellID)
        // 设置预估行高和自动计算
        tableView.estimatedRowHeight = 200
    	tableView.rowHeight = UITableViewAutomaticDimension
        // 设置分割线样式
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: #selector(getStatusData), for: UIControlEvents.valueChanged)
        tableView.tableFooterView = bottomRefreshView
    }
    
    // MARK: - 监听方法
    func rightBtnClikc() {
        let vc = MFTempViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func leftBtnClikc() {
        print("zuo")
    }
    
    func backBtnClick() {
        
    }
    
    // 提示控件动画
    fileprivate func startTipAnimation(message: String) {
        if tipLabel.isHidden == false {
            return
        }
        tipLabel.isHidden = false
        tipLabel.text = message
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLabel.transform = CGAffineTransform(translationX: 0, y: 35)
            }) { (_) in
                UIView.animate(withDuration: 1.0, animations: {
                     self.tipLabel.transform = CGAffineTransform.identity
                    }, completion: { (_) in
                        self.tipLabel.isHidden = true
                })
        }
    }
}

// MARK: - 请求数据
extension MFHomeViewController {
    func getStatusData() {
        statusListViewModel.getHomeData(isPullup: bottomRefreshView.isAnimating) { (isSuccess, message) in
            if !self.bottomRefreshView.isAnimating {
                self.startTipAnimation(message: message)
            }
            if isSuccess {
                print("请求成功")
                self.tableView.reloadData()
            } else {
                print("请求失败")
            }
            self.endRefresh()
        }
    }
    // 停止刷新，包括上拉和下拉刷新
    func endRefresh() {
        print("数据下载完毕，停止刷新")
        refresh.endRefreshing()
        bottomRefreshView.stopAnimating()
    }
}


extension MFHomeViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - tableView数据源方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusListViewModel.statusDataArr.count 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: statusCellID, for: indexPath) as! MFStatusCell
        cell.statusViewModel = statusListViewModel.statusDataArr[indexPath.row]
        return cell
    }
    
    // MARK: - 代理方法
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (statusListViewModel.statusDataArr.count - 1) && !bottomRefreshView.isAnimating{
            bottomRefreshView.startAnimating()
            getStatusData()
        }
    }
}



