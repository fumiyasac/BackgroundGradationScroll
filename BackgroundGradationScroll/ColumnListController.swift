//
//  ColumnListController.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/17.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class ColumnListController: UIViewController {

    //UIPageViewController側で設定したIndex値を格納するメンバ変数
    var targetIndex: String? = nil
    
    //UIパーツの配置
    @IBOutlet weak var columnListCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DEBUG: 受け取ったインデックス値の表示
        print("受け取ったインデックス値：\(targetIndex)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
