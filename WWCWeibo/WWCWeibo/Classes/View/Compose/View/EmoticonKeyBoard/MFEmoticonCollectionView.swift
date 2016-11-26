//
//  MFEmoticonCollectionView.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/11/4.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFEmoticonCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 搭建界面
    private func setupUI() {
        backgroundColor = superview?.backgroundColor
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let flowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = self.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
    }

}
