//
//  MFEmoticonCollectionViewCell.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/11/5.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFEmoticonCollectionViewCell: UICollectionViewCell {
    
    // MARK: - 控件
    // 展示当前cell是哪一组合哪一页
    lazy private var numLabel: UILabel = {
       let num = UILabel()
        num.font = UIFont.systemFont(ofSize: 30)
        num.textColor = UIColor.red
        num.textAlignment = .center
        return num
    }()
    
    // 索引
    var indexPath: IndexPath? {
        didSet {
            if (indexPath != nil) {
                numLabel.text = "\(indexPath!.section)组\(indexPath!.item)页"
            }
        }
    }
    
    // 存储20个按钮的数组
    private var emoticonBtnArr: [MFButton] = [MFButton]()
    
    // 接收传入的表情数据
    var emoticonArr: [MFEmoticonModel]? {
        didSet {
            guard let arr = emoticonArr else {
                return
            }
            deleteBtn.isHidden = emoticonArr!.count == 0 ? true : false
            for btn in emoticonBtnArr {
                btn.isHidden = true
            }
            for (i, emoticonModel) in arr.enumerated() {
                let btn = emoticonBtnArr[i]
                btn.isHidden = false
                btn.emoticonModel = emoticonModel
                if emoticonModel.type == "0" {
                    
                    btn.setImage(UIImage(contentsOfFile: emoticonModel.fullPath!), for: .normal)
                    btn.setTitle(nil, for: .normal)
                    
                } else {
                    btn.setTitle((emoticonModel.code! as NSString).emoji(), for: .normal)
                    btn.setImage(nil, for: .normal)
                }
            }
        }
    }
    
    // 删除按钮
    private lazy var deleteBtn: UIButton = {
        let btn = UIButton(setHighlightedImageName: "compose_emotion_delete", title: nil, target: self, action: #selector(deleteBtenClick))
        return btn
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
        // 添加控件
        addEmoticonBtn()
        contentView.addSubview(numLabel)
        contentView.addSubview(deleteBtn)
        // 设置约束
        numLabel.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
    }
    
    // 添加20个按钮
    private func addEmoticonBtn() {
        for _ in 0..<20 {
            let btn = MFButton()
            btn.isHidden = true
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 33)
            emoticonBtnArr.append(btn)
            btn.addTarget(self, action: #selector(emoticonBtnClick(btn:)), for: .touchUpInside)
            contentView.addSubview(btn)
        }
    }
    
    // 布局按钮
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let btnW = contentView.bounds.size.width / 7
        let btnH = contentView.bounds.size.height / 3
        for (i, btn) in emoticonBtnArr.enumerated() {
            // 列数
            let colNum = i % 7
            // 行数
            let rowNum = i / 7
            btn.x = CGFloat(colNum) * btnW
            btn.y = CGFloat(rowNum) * btnH
            btn.size = CGSize(width: btnW, height: btnH)
        }
        deleteBtn.centerX = contentView.width - btnW * 0.5
        deleteBtn.centerY = contentView.height - btnH * 0.5
    }
    
    // MARK: - 监听事件
    func emoticonBtnClick(btn: MFButton) {
        NotificationCenter.default.post(name: NSNotification.Name(MFEmoticonButtonNotification), object: btn.emoticonModel)
    }
    
    func deleteBtenClick() {
        NotificationCenter.default.post(name: NSNotification.Name(MFEmoticonDeleteButtonNotification), object: nil)
    }
}
