//
//  MFStatusPictrueView.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/28.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit
import SDWebImage

let cellID = "cellID"
let margin: CGFloat = 5
let cellWH = (MFSCREENSIZEW - margin * 2 - 20) / 3
class MFStatusPictrueView: UICollectionView {
    
    // MARK: - 属性
    var picUrls: [MFPictureInfoModel]? {
        didSet {
            dealScaleSize(count: picUrls?.count ?? 0)
            reloadData()
        }
    }
    
    var numLabel: UILabel = {
       let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 30)
        lab.textColor = UIColor.red
        return lab
    }()
    
    func dealScaleSize(count: Int) {
        // 单张图片的处理
        if count == 1 {
            let key = picUrls?.last?.thumbnail_pic ?? ""
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key)
            
            if image != nil {
                let size = image?.size
                self.snp.updateConstraints { (make) in
                    make.size.equalTo(size!)
                }
                layoutIfNeeded()
                let flowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
                flowLayout.itemSize = size!
                flowLayout.minimumLineSpacing = 0
                flowLayout.minimumInteritemSpacing = 0
                return
            }
        }
        
        // 行数和列数
        let row = (count - 1) / 3 + 1
        let col = count >= 3 ? 3 : count
        // 最终的宽和高
        let h = CGFloat(row) * cellWH + CGFloat(row - 1) * margin
        let w = CGFloat(col) * cellWH + CGFloat(col - 1) * margin
        // 设置约束
        self.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize(width: w, height: h))
        }
        
        layoutIfNeeded()
        // 设置item
        let flowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: cellWH, height: cellWH)
        flowLayout.minimumLineSpacing = margin
        flowLayout.minimumInteritemSpacing = margin
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 搭建界面
    func setupUI() {
        self.dataSource = self
        // 注册
        self.register(MFStatusPictrueViewCell.self, forCellWithReuseIdentifier: cellID)
        // 约束
        self.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 115))
        }
        layoutIfNeeded()
        let flowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
    }
}


extension MFStatusPictrueView: UICollectionViewDataSource {
    // MARK: - 数据源方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MFStatusPictrueViewCell
        cell.pictureInfoModel = picUrls![indexPath.item]
        return cell
    }
}

// // MARK: - 自定义item
class MFStatusPictrueViewCell: UICollectionViewCell {
    // 图片框
    lazy var imageV: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    // 模型
    var pictureInfoModel: MFPictureInfoModel? {
        didSet {
            imageV.mf_setImage(withURLString: pictureInfoModel?.thumbnail_pic, placeholderImageName: "avatar_default")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 搭建界面
    func setupUI() {
        // 添加控件
        contentView.addSubview(imageV)
        // 设置约束
        imageV.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
}





