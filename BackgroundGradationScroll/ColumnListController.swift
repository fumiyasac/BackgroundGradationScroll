//
//  ColumnListController.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/17.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class ColumnListController: UIViewController {

    //テスト
    @IBOutlet weak var testNumber: UILabel!
    var labelStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テスト
        testNumber.text = labelStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
