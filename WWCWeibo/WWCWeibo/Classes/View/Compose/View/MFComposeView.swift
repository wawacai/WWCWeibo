//
//  MFComposeView.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/11/1.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit
import YYModel
import pop

class MFComposeView: UIView {
    
    // MARK: - 控件
    // 背景图片
    private lazy var bgImageView: UIImageView = {
       let image = self.getScreenSnapshoot().applyLightEffect()
        let bg = UIImageView(image: image)
        return bg
    }()
    // 标语
    private lazy var sloganImageView: UIImageView = UIImageView(image: UIImage(named: "compose_slogan"))
    // 模型数组
    private lazy var composeMenuArr: [MFComposeMenuModel] = self.loadMenuData()
    // 记录按钮的数组
    private lazy var composeBtnArr: [UIButton] = [UIButton]()
    // 记录添加者
    private var target: UIViewController?

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
		
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    // MARK: - 搭建界面
    private func setupUI() {
        // 添加控件
    	addSubview(bgImageView)
        addSubview(sloganImageView)
        addBtn()
        // 约束
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        sloganImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgImageView)
            make.top.equalTo(bgImageView).offset(100)
        }
        
        startPopAnimation(isUp: true)
    }
    // 获得屏幕截图
    private func getScreenSnapshoot() -> UIImage {
        let window = UIApplication.shared.keyWindow!
        // 开启图片上下文
        UIGraphicsBeginImageContext(window.bounds.size)
        // 根据指定区域绘制
        let rect = CGRect(origin: CGPoint.zero, size: window.bounds.size)
        window.drawHierarchy(in: rect, afterScreenUpdates: false)
        // 从图片上下文中获取绘制的图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭图片上下文
        UIGraphicsEndImageContext()
        return image!
    }
    // 添加六个按钮
    private func addBtn() {
        let btnH:CGFloat = 110
        let btnW:CGFloat = 80
        let margin:CGFloat = (MFSCREENSIZEW - 3 * btnW) / 4
        
        for i in 0..<composeMenuArr.count {
            // 行
            let rowNum = i / 3
            // 列
            let colNum = i % 3
            
            let btn = MFComposeButton()
            let model = composeMenuArr[i]
            btn.setTitle(model.title, for: .normal)
            btn.setImage(UIImage(named: model.icon!), for: .normal)
            // 设置frame
            btn.frame.size = CGSize(width: btnW, height: btnH)
            let x: CGFloat = CGFloat(colNum + 1) * margin + CGFloat(colNum) * btnW
            let y: CGFloat = CGFloat(rowNum) * (40 + btnH) + MFSCREENSIZEH
            btn.frame.origin = CGPoint(x: x, y: y)
            
            btn.tag = i
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            composeBtnArr.append(btn)
            addSubview(btn)
        }
    }
    // 开始pop动画
    private func startPopAnimation(isUp: Bool) {
        if  !isUp {
            composeBtnArr = composeBtnArr.reversed()
        }
        for (i, btn) in composeBtnArr.enumerated() {
            let springAnim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
            if isUp {
                springAnim?.toValue = NSValue(cgPoint: CGPoint(x: btn.center.x, y: btn.center.y - 350))
            } else {
                springAnim?.toValue = NSValue(cgPoint: CGPoint(x: btn.center.x, y: btn.center.y + 350))
            }
            springAnim?.beginTime = CACurrentMediaTime() + Double(i) * 0.025
            springAnim?.springBounciness = 10
            springAnim?.springSpeed = 10
            btn.pop_add(springAnim, forKey: nil)
        }
        
    }
    
    // MARK: - 监听事件
    @objc private func btnClick(btn: UIButton) {
        
        UIView.animate(withDuration: 0.25, animations: { 
            for button in self.composeBtnArr {
                button.alpha = 0.2
                if btn == button {
                    btn.transform = CGAffineTransform(scaleX: 2, y: 2)
                } else {
                    button.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }
            }
            
            }, completion: { (_) in
                
            UIView.animate(withDuration: 0.25, animations: { 
                for button in self.composeBtnArr {
                    button.alpha = 1
                    button.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                }, completion: { (_) in
                    let model = self.composeMenuArr[btn.tag]
                    let className = NSClassFromString(model.className!) as! UIViewController.Type
                    let composeVc = className.init()
                    let nav = UINavigationController(rootViewController: composeVc)
                    self.target?.present(nav, animated: true, completion: { 
                        self.removeFromSuperview()
                    })
            })
        })
    }
    
    func show(target: UIViewController) {
        self.target = target
        target.view.addSubview(self)
        startPopAnimation(isUp: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPopAnimation(isUp: false)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { 
            self.removeFromSuperview()
        }
    }
    
    // 加载plist数据
    private func loadMenuData() -> [MFComposeMenuModel] {
        let filePath = Bundle.main.path(forResource: "compose.plist", ofType: nil)
        let dictArr = NSArray(contentsOfFile: filePath!)
        
        let tempArr = NSArray.yy_modelArray(with: MFComposeMenuModel.self, json: dictArr!) as! [MFComposeMenuModel]
        return tempArr
    }
}
