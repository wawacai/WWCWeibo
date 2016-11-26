//
//  MFTempViewController.swift
//  WWCWeibo
//
//  Created by 彭作青 on 2016/10/22.
//  Copyright © 2016年 彭作青. All rights reserved.
//

import UIKit

class MFTempViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = MFTHEMECOLOR
        
        setupUI()
    }
    
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(setHighlightedImageName: nil, title: "PUSH", target: self, action: #selector(pushBtnClick))
        navigationItem.title = "是\(navigationController?.childViewControllers.count ?? 1)控制器"
    }
	
    func pushBtnClick() {
        let vc = MFTempViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
