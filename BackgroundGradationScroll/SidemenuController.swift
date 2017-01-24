//
//  SidemenuController.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/24.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class SidemenuController: UIViewController {

    //UIパーツの配置
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var bannerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //バナー部分のボタンを押下した際のアクション
    @IBAction func bannerButtonAction(_ sender: UIButton) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
