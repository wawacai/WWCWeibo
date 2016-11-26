//
//  MFComposeViewController.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/22.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit
import SVProgressHUD

class MFComposeViewController: UIViewController {
    
    // MARK: - 懒加载控件
    // 发送按钮
    private lazy var sendBtn: UIButton = {
        let btn = UIButton(backgroundImageName: "common_button_orange", imageName: nil, target: self, action: #selector(sendBtnClick))
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .disabled)
        btn.setTitleColor(UIColor.gray, for: .disabled)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("发送", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: MFNormalFont)
        //  设置大小
        btn.frame.size = CGSize(width: 45, height: 35)
        return btn
    }()
    
    // 中间标题
    private lazy var titleLabel: UILabel = {
       let lab = UILabel()
        lab.textColor = UIColor.darkGray
        lab.font = UIFont.systemFont(ofSize: 17)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.text = "发微博\n娃娃菜"
        if let name = MFUserAccountViewModel.sharedTools.userAccountModel?.screen_name {
            let title = "发微博\n\(name)"
            // 创建富文本
            let attri: NSMutableAttributedString = NSMutableAttributedString(string: title)
            let range: NSRange = (title as NSString).range(of: name)
            attri.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.brown], range: range)
            lab.attributedText = attri
        } else {
            lab.text = "发微博"
        }
        lab.sizeToFit()
        return lab
    }()
    
    // textView
    fileprivate lazy var composeTextView: MFComposeTextView = {
       let textView = MFComposeTextView()
        textView.placeHolder = "今天天气好，适合打豆豆~今天天气好，适合打豆豆~今天天气好，适合打豆豆~今天天气好，适合打豆豆~今天天气好，适合打豆豆~"
        textView.font = UIFont.systemFont(ofSize: MFNormalFont)
        textView.delegate = self
        return textView
    }()
    
    // 底部toolBar
    lazy var composeToolBar: MFComposeToolBar = MFComposeToolBar()
    
    // 中间显示选中的图片的collectionView
    fileprivate lazy var composePictureView: MFComposePictureView = {
       let picView = MFComposePictureView()
        picView.backgroundColor = self.composeTextView.backgroundColor
        return picView
    }()
    
    // 表情键盘
    fileprivate lazy var emoticonKeyboard: MFEmoticonKeyBoard = {
       let keyboardView = MFEmoticonKeyBoard()
        keyboardView.bounds.size = CGSize(width: self.composeTextView.bounds.size.width, height: 216)
        return keyboardView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
		setupUI()
    }
    
    // MARK: - 搭建界面
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        setupNav()
        
        view.addSubview(composeTextView)
        view.addSubview(composeToolBar)
        composeTextView.addSubview(composePictureView)
        
        composeToolBar.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self.view)
            make.height.equalTo(35)
        }
        composeTextView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(composeToolBar.snp.top)
        }
        composePictureView.snp.makeConstraints { (make) in
            make.top.equalTo(composeTextView).offset(100)
            make.width.equalTo(composeTextView).offset(-20)
            make.height.equalTo(composeTextView.snp.width).offset(-20)
            make.centerX.equalTo(composeTextView)
        }
        
        // 监听通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(noti:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(emoticonBtnClick(noti:)), name: NSNotification.Name(MFEmoticonButtonNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteText), name: NSNotification.Name(MFEmoticonDeleteButtonNotification), object: nil)
        
        // toolBar闭包
        composeToolBar.callBack = { [weak self] (type) in
            switch type {
            case .camera:
                print("相机")
                self?.selectedPicture()
            case .mention:
                print("@")
            case .trend:
                print("热门")
            case .emoticon:
                print("表情")
                self?.selectedEmoticon()
            case .add:
                print("添加")
            }
        }
        composePictureView.callBack = {[weak self] in
            self?.selectedPicture()
        }
    }
    
    // 设置导航栏
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(setHighlightedImageName: nil, title: "取消", target: self, action: #selector(cancelBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendBtn)
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.titleView = titleLabel
    }
    
    // MARK: - 监听事件
    @objc private func cancelBtnClick() {
        composeTextView.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func sendBtnClick() {
        let status = composeTextView.emoticonStr!
        if composePictureView.imageArr.count > 0 {
            // 发送带一张图片的微博
            MFNetworkingTool.sharedTool.upload(status: status, picture: composePictureView.imageArr.first!, success: { (response) in
                SVProgressHUD.showSuccess(withStatus: "发送成功")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                    self.cancelBtnClick()
                })
            }, failure: { (error) in
                SVProgressHUD.showError(withStatus: "发送失败")
            })
        } else {
            // 发送文字微博
            
            MFNetworkingTool.sharedTool.update(status: status, success: { (_) in
                SVProgressHUD.showSuccess(withStatus: "发送成功")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                    self.cancelBtnClick()
                })
            }) { (error) in
                SVProgressHUD.showError(withStatus: "发送失败")
                print(error)
            }
        }
    }
    
    func keyboardChange(noti: Notification) {
        let rect = (noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: duration, animations: {
            self.composeToolBar.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.view.snp.bottom).offset(-rect.size.height)
            })
            self.view.layoutIfNeeded()
        })
    }
    
    // 监听表情键盘发来的通知
    func emoticonBtnClick(noti: Notification) {
        let model = noti.object as! MFEmoticonModel
        MFComposeEmoticonViewModel.sharedTool.saveEmoticon(model: model)
        emoticonKeyboard.reloadRecentData()
        
        if model.type == "0" {
            // 记录上次的富文本
            let lastAttribute = NSMutableAttributedString(attributedString: composeTextView.attributedText)
            // 根据全路径获得图片
            let image = UIImage(contentsOfFile: model.fullPath!)
            // 创建文本附件
            let attachment = MFTextAttachment()
            attachment.emotionModel = model
            // 把图片设置为文本附件的图片
            attachment.image = image
            // 设置图片显示的大小
            let fontHeight = composeTextView.font!.lineHeight
            attachment.bounds = CGRect(x: 0, y: -4, width: fontHeight, height: fontHeight)
            // 根据文本附件创建富文本
            let attribute = NSAttributedString(attachment: attachment)
            // 获取选中范围
            var selectedR = composeTextView.selectedRange
            // 替换选中范围
            lastAttribute.replaceCharacters(in: selectedR, with: attribute)
            // 设置富文本的文字大小
            lastAttribute.addAttribute(NSFontAttributeName, value: composeTextView.font!, range: NSMakeRange(0, lastAttribute.length))
            // 设置为textView的富文本
            composeTextView.attributedText = lastAttribute
            // 替换结束后设置选中范围的初始位置
            selectedR.location += 1
            // 设置选中的长度
            selectedR.length = 0
            // 给composeTextView赋值
			composeTextView.selectedRange = selectedR
            // 发送文字改变的通知
            NotificationCenter.default.post(name: NSNotification.Name.UITextViewTextDidChange, object: nil)
            // 调用代理方法
            self.textViewDidChange(composeTextView)
        } else {
            composeTextView.insertText((model.code! as NSString).emoji())
        }
    }
    
    // 监听删除按钮
    func deleteText() {
        composeTextView.deleteBackward()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - toolBar按钮点击执行的相关方法
extension MFComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 点击图片按钮的逻辑处理
    func selectedPicture() {
        let pickerController = UIImagePickerController()
        // 设置代理
        pickerController.delegate = self
        // 判断支持相机还是相册
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.sourceType = .camera
        } else {
            pickerController.sourceType = .photoLibrary
        }
        
        if UIImagePickerController.isCameraDeviceAvailable(.front) {
            print("支持前置摄像头")
        }
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            print("支持后置摄像头")
        }
        if UIImagePickerController.isCameraDeviceAvailable(.front) == false && UIImagePickerController.isCameraDeviceAvailable(.rear) == false {
            print("摄像头不可用")
        }
        // 允许编辑
//        pickerController.allowsEditing = true
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImage(scaleWidth: 200, image: selectImage)
        composePictureView.addImage(image: scaledImage)
        // 如果实现了代理方法, 那么自己去 dismis 图片浏览器
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 如果实现了代理方法, 那么自己去 dismis 图片浏览器
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 根据传入的宽度压缩图片
    func scaleImage(scaleWidth: CGFloat, image: UIImage) -> UIImage {
        let scaleHeight = image.size.height / image.size.width * scaleWidth
        let scaleSize = CGSize(width: scaleWidth, height: scaleHeight)
        
        // 开启图片上下文
        UIGraphicsBeginImageContext(scaleSize)
        image.draw(in: CGRect(origin: CGPoint.zero, size: scaleSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭图片上下文
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // 点击表情按钮的监听事件
    func selectedEmoticon() {
        if composeTextView.inputView == nil {
            composeTextView.inputView = emoticonKeyboard
        	composeToolBar.showIcon(isEmoticon: true)
        } else {
            composeTextView.inputView = nil
            composeToolBar.showIcon(isEmoticon: false)
        }
        // 成为第一响应者
        composeTextView.becomeFirstResponder()
//        composeTextView.inputAccessoryView = emoticonKeyboard
        // 刷新输入视图
        composeTextView.reloadInputViews()
    }
}

// MARK: - UITextViewDelegate代理方法
extension MFComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
}
