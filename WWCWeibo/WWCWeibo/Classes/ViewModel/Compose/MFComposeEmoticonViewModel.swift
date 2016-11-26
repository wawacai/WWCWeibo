//
//  MFComposeEmoticonViewModel.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/11/6.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

let numberOfPage = 20
let recentEmoticonPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last as! NSString).appendingPathComponent("recentEmoticon.db")
class MFComposeEmoticonViewModel: NSObject {
//     全局访问点
    static let sharedTool: MFComposeEmoticonViewModel = MFComposeEmoticonViewModel()
    
    // bundle对象
    lazy var emoticonBundle: Bundle = {
        let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil)
        let bun = Bundle.init(path: path!)!
        return bun
    }()
    
    // 最近表情
    lazy var latelyEmoticonArr: [MFEmoticonModel] = {
       let arr = NSKeyedUnarchiver.unarchiveObject(withFile: recentEmoticonPath) as? [MFEmoticonModel]
        if arr == nil {
            let emoticonArr = [MFEmoticonModel]()
            return emoticonArr
        } else {
            return arr!
        }
    }()
    
    // 默认表情
    private lazy var defaultEmoticonArr: [MFEmoticonModel] = {
        return self.loadEmoticonModelArr(folderName: "default", fileName: "info.plist")
    }()
    
    // emoji表情
    private lazy var emojiEmoticonArr: [MFEmoticonModel] = {
        return self.loadEmoticonModelArr(folderName: "emoji", fileName: "info.plist")
    }()
    
    // 浪小花表情
    private lazy var lxhEmoticonArr: [MFEmoticonModel] = {
        return self.loadEmoticonModelArr(folderName: "lxh", fileName: "info.plist")
    }()
    
    // 保存所有表情的三维数组
    lazy var allEmoticonArr: [[[MFEmoticonModel]]] = {
        return [
            [self.latelyEmoticonArr],
            self.secondEmoticonArr(emoticonArr: self.defaultEmoticonArr),
            self.secondEmoticonArr(emoticonArr: self.emojiEmoticonArr),
            self.secondEmoticonArr(emoticonArr: self.lxhEmoticonArr)
        ]
        
    }()
    
    // 构造函数私有化
    override init() {
        super.init()
    }
    
    // 获得表情模型数组
    private func loadEmoticonModelArr(folderName: String, fileName: String) -> [MFEmoticonModel] {
        let subPath = folderName + "/" + fileName
        let path = emoticonBundle.path(forResource: subPath, ofType: nil)
        let dictArr = NSArray(contentsOfFile: path!)!
        let emoticonModelArr = NSArray.yy_modelArray(with: MFEmoticonModel.self, json: dictArr) as! [MFEmoticonModel]
        // 遍历模型数组，判断是否是图片模型
        for model in emoticonModelArr {
            if model.type == "0" {
                model.fullPath = emoticonBundle.path(forResource: folderName, ofType: nil)! + "/" + model.png!
                model.folderPath = folderName
            }
        }
        return emoticonModelArr
    }
    
    // 截取元素，变为二维数组
    private func secondEmoticonArr(emoticonArr: [MFEmoticonModel]) -> [[MFEmoticonModel]] {
        var secondArr: [[MFEmoticonModel]] = [[MFEmoticonModel]]()
        let pageNum = (emoticonArr.count - 1) / numberOfPage + 1
        for i in 0..<pageNum {
            let loc = i * numberOfPage
            var length = numberOfPage
            if loc + length > emoticonArr.count {
                length = emoticonArr.count - loc
            }
            let tempArr = (emoticonArr as NSArray).subarray(with: NSRange(location: loc, length: length)) as! [MFEmoticonModel]
            secondArr.append(tempArr)
        }
        return secondArr
    }
    
    // 保存点击第按钮
    func saveEmoticon(model: MFEmoticonModel) {
        for (i, emot) in latelyEmoticonArr.enumerated() {
            if model.type == "0" {
                if emot.chs == model.chs {
                    latelyEmoticonArr.remove(at: i)
                    break
                }
            } else {
                if emot.code == model.code {
                    latelyEmoticonArr.remove(at: i)
                    break
                }
            }
        }
        latelyEmoticonArr.insert(model, at: 0)
        while latelyEmoticonArr.count > 20 {
            latelyEmoticonArr.removeLast()
        }
        allEmoticonArr[0][0] = latelyEmoticonArr
        NSKeyedArchiver.archiveRootObject(latelyEmoticonArr, toFile: recentEmoticonPath)
        
    }
}
