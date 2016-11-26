//
//  Ext+UIImageView.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/27.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// 快捷下载图片的方法
    ///
    /// - parameter withURLString:        地址
    /// - parameter placeholderImageName: 占位图名字
    func mf_setImage(withURLString: String?, placeholderImageName: String?) {
        let url = URL(string: withURLString ?? "")
        guard let u = url else {
            return
        }
        self.sd_setImage(with: u, placeholderImage: UIImage(named: placeholderImageName ?? ""))
    }
    
    convenience init(imageName: String) {
        self.init()
        self.image = UIImage(named: imageName)
    }
}
