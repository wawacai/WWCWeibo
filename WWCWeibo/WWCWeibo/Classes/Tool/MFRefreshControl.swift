//
//  MFRefreshControl.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/31.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

// 下拉刷新的状态
private enum MFRefreshType: Int {
    case normal = 0
    case pulling = 1
    case refreshing = 2
}
private let refreshHeight: CGFloat = 35

class MFRefreshControl: UIControl {
    
    // MARK: - 控件
    // 记录父控件
    private var currentScorllView: UIScrollView?
    // 下拉刷新箭头
    private lazy var pullDownImageView: UIImageView = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
    // 文字
    private lazy var messageLabel: UILabel = {
       let m = UILabel()
        m.text = "下拉刷新"
        m.font = UIFont.systemFont(ofSize: 12)
        return m
    }()
    // 菊花
    private lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    // 记录状态
    private var refreshType: MFRefreshType = .normal {
        didSet {
            switch refreshType {
            case .normal:
                UIView.animate(withDuration: 0.25, animations: { 
                    self.pullDownImageView.transform = CGAffineTransform.identity
                })
                pullDownImageView.isHidden = false
                messageLabel.text = "下拉刷新"
                activityIndicator.stopAnimating()
                if oldValue == .refreshing {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.currentScorllView?.contentInset.top -= refreshHeight
                    })
                }
                
            case .pulling:
                UIView.animate(withDuration: 0.25, animations: { 
                    self.pullDownImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                })
                messageLabel.text = "松手即刷新"
                
            case .refreshing:
                pullDownImageView.isHidden = true
                UIView.animate(withDuration: 0.25, animations: {
                    self.currentScorllView?.contentInset.top += refreshHeight
                })
                messageLabel.text = "正在刷新"
                activityIndicator.startAnimating()
                sendActions(for: .valueChanged)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: -35, width: UIScreen.main.bounds.size.width, height: refreshHeight)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 搭建界面
    private func setupUI() {
        // 添加控件
        addSubview(pullDownImageView)
        addSubview(messageLabel)
        addSubview(activityIndicator)
        
        // 添加约束
        pullDownImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: pullDownImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -35))
        addConstraint(NSLayoutConstraint(item: pullDownImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .left, relatedBy: .equal, toItem: pullDownImageView, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: pullDownImageView, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: pullDownImageView, attribute: .centerY, multiplier: 1, constant: 0))
    }
    // 获取父控件
    override func willMove(toSuperview newSuperview: UIView?) {
        if let scorllView = newSuperview as? UIScrollView {
            scorllView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
            currentScorllView = scorllView
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = currentScorllView  else {
            return
        }
        // 临界值
        let maxY = -(scrollView.contentInset.top + refreshHeight)
        let contentOffsetY = scrollView.contentOffset.y
        if scrollView.isDragging {
            
            if contentOffsetY >= maxY && refreshType == .pulling {
                refreshType = .normal
            } else if contentOffsetY < maxY && refreshType == .normal {
                refreshType = .pulling
            }
            
        } else {
            if refreshType == .pulling {
                refreshType = .refreshing
            }
        }
    }
    // 停止的方法
    func endRefreshing() {
        refreshType = .normal
    }
    
    deinit {
        currentScorllView?.removeObserver(self, forKeyPath: "contentOffset", context: nil)
    }

}
