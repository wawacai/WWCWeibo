//
//  MFEmoticonKeyBoard.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/11/4.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

let EmoticonCollectionViewCellID = "EmoticonCollectionViewCellID"
class MFEmoticonKeyBoard: UIView {
    
    // MARK: - 懒加载控件
    // 底部的toolBar
    lazy var toolBar: MFEmoticonToolBar = MFEmoticonToolBar()
    
    // 添加表情的collectionView
    lazy var emoticonCollectionView: MFEmoticonCollectionView = MFEmoticonCollectionView()
    
    // viewModel
    lazy var emoticonViewModel: MFComposeEmoticonViewModel = MFComposeEmoticonViewModel.sharedTool
    
    // 页数指示器
    lazy var pageControl: UIPageControl = {
       let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_selected")!)
        pc.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_normal")!)
        pc.hidesForSinglePage = true
        return pc
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    // 搭建界面
    private func setupUI() {
        backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
        // 当界面创建完并且绑定数据后就滚动到默认的位置
        let defaultIndexPath = IndexPath(item: 0, section: 1)
        DispatchQueue.main.async { 
            self.emoticonCollectionView.scrollToItem(at: defaultIndexPath, at: .left, animated: false)
        }
        
        // 通知
//        NotificationCenter.default.addObserver(self, selector: #selector(emoticonBtnClick(noti:)), name: NSNotification.Name(MFEmoticonButtonNotification), object: nil)
        
        // 设置数据源
        emoticonCollectionView.dataSource = self
        // 设置代理
        emoticonCollectionView.delegate = self
        // 注册
        emoticonCollectionView.register(MFEmoticonCollectionViewCell.self, forCellWithReuseIdentifier: EmoticonCollectionViewCellID)
        
        // 添加控件
        addSubview(toolBar)
        addSubview(emoticonCollectionView)
        addSubview(pageControl)
        // 约束
        toolBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(35)
        }
        emoticonCollectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(toolBar.snp.top)
        }
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(emoticonCollectionView).offset(10)
            make.centerX.equalTo(emoticonCollectionView)
        }
        
        // 实例化toolBar的callBack属性
        toolBar.callBack = { [weak self] (btnType) in
            let indexPath = IndexPath(item: 0, section: btnType.rawValue)
            self?.emoticonCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            switch btnType {
            case .latelyEmoticon:
                print("最近表情")
            case .defaultEmoticon:
                print("默认表情")
            case .emojiEmoticon:
                print("emoji")
            case .lxhEmoticon:
                print("浪小花")
            }
        }
    }
    // MARK: - 监听事件
    func toolBarBtnClick() {
       
    }
    
    func reloadRecentData() {
         let index = IndexPath(item: 0, section: 0)
        emoticonCollectionView.reloadItems(at: [index])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 数据源方法,代理方法
extension MFEmoticonKeyBoard: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emoticonViewModel.allEmoticonArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return emoticonViewModel.allEmoticonArr[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCollectionViewCellID, for: indexPath) as! MFEmoticonCollectionViewCell
        cell.emoticonArr = emoticonViewModel.allEmoticonArr[indexPath.section][indexPath.item]
        cell.indexPath = indexPath
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + emoticonCollectionView.width * 0.5
        let centerY = scrollView.contentOffset.y + emoticonCollectionView.height * 0.5
        let currentCenter = CGPoint(x: centerX, y: centerY)
        if let indexP = emoticonCollectionView.indexPathForItem(at: currentCenter) {
        	toolBar.selectedBtn(section: indexP.section)
            pageControl.numberOfPages = emoticonViewModel.allEmoticonArr[indexP.section].count
            pageControl.currentPage = indexP.item
        }
    }
    
}
