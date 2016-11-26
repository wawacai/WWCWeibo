//
//  MFEmoticonModel.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/11/6.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFEmoticonModel: NSObject, NSCoding {
    // emoji表情的编码
    var code: String?
    // 表情的类型，1代表emoji，0代表图片
    var type: String?
    //  表情描述 -> 以后发给新浪微博需要发送这个字段
    var chs: String?
    //  表情图片名称
    var png: String?
    // 图片的全路径
    var fullPath: String?
    // 保存文件的文件夹路径
    var folderPath: String?
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(code, forKey: "code")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(chs, forKey: "chs")
        aCoder.encode(png, forKey: "png")
        aCoder.encode(fullPath, forKey: "fullPath")
        aCoder.encode(folderPath, forKey: "folderPath")
    }
    
    required init?(coder aDecoder: NSCoder) {
        code = aDecoder.decodeObject(forKey: "code") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        chs = aDecoder.decodeObject(forKey: "chs") as? String
        png = aDecoder.decodeObject(forKey: "png") as? String
        fullPath = aDecoder.decodeObject(forKey: "fullPath") as? String
        folderPath = aDecoder.decodeObject(forKey: "folderPath") as? String
        
        if type == "0" {
            let path = MFComposeEmoticonViewModel.sharedTool.emoticonBundle.path(forResource: folderPath, ofType: nil)! + "/" + png!
            fullPath = path
        }
    }
}
