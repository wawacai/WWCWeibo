//
//  MFComposePictureView.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/11/3.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

private let pictureCellID = "pictureCellID"
class MFComposePictureView: UICollectionView {
    // MARK: - 懒加载控件
    // 保存传入的图片数组
    lazy var imageArr: [UIImage] = [UIImage]()
    // 回调的闭包
    var callBack: (()->())?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 搭建界面
    private func setupUI() {
        self.dataSource = self
        self.delegate = self
        isHidden = true
        // 注册
        register(MFComposePictureCell.self, forCellWithReuseIdentifier: pictureCellID)
    }
    // 提供给外界的增加图片的方法
    func addImage(image: UIImage) {
        if imageArr.count == 9 {
            return
        }
        isHidden = false
        imageArr.append(image)
        reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let flowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        let margin:CGFloat = 5
        let itemWidth = (frame.size.width - 2 * margin) / 3
        let itemHeight = itemWidth
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumLineSpacing = margin
        flowLayout.minimumInteritemSpacing = margin
    }

}

// MARK: - 代理方法
extension MFComposePictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArr.count == 0 || imageArr.count == 9 {
            return imageArr.count
        } else {
            return imageArr.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictureCellID, for: indexPath) as! MFComposePictureCell
        cell.index = indexPath
        if indexPath.item == imageArr.count {
            cell.image = nil
        } else {
            cell.image = imageArr[indexPath.item]
            cell.callBack = { [weak self] (index: Int) in
                self?.imageArr.remove(at: index)
                // 删除后如果图片数量为0，则隐藏collectionView
                if self?.imageArr.count == 0 {
                    self?.isHidden = true
                }
                self?.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == imageArr.count {
            callBack?()
        }
    }
}

// MARK: - 自定义item
class MFComposePictureCell: UICollectionViewCell {
    // MARK: - 加载控件
    private lazy var pictureImageView: UIImageView = UIImageView()
    // 删除的闭包
    var callBack: ((Int)->())?
    // cell的索引
    var index: IndexPath?
    // 图片
    var image: UIImage? {
        didSet {
            if image != nil {
                pictureImageView.image = image
                deleteBtn.isHidden = false
            } else {
                deleteBtn.isHidden = true
                pictureImageView.image = UIImage(named: "compose_pic_add")
            }
        }
    }
    // 删除图片按钮
    lazy var deleteBtn: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "compose_photo_close"), for: .normal)
        btn.addTarget(self, action: #selector(deleteBtnClick(btn:)), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(pictureImageView)

        addSubview(deleteBtn)
        
        pictureImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        deleteBtn.snp.makeConstraints { (make) in
            make.top.right.equalTo(contentView)
        }
    }
    
    // 监听事件
    func deleteBtnClick(btn: UIButton) {
        if let idx = index {
            callBack?(idx.item)
        }
    }
}










