//
//  LinkInfoCell.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/02/04.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class LinkInfoCell: UITableViewCell {

    //UIパーツの配置
    @IBOutlet weak var linkHotpepperButton: UIButton!
    @IBOutlet weak var linkTabelogButton: UIButton!
    @IBOutlet weak var linkRemarkText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellInitialSetting()
    }

    //「Hotpepperの情報を見る」ボタン押下時のアクション
    @IBAction func linkHotpepperAction(_ sender: UIButton) {
    }

    //「食べログの情報を見る」ボタン押下時のアクション
    @IBAction func linkTabelogAction(_ sender: UIButton) {
    }

    //セルの初期設定に関するメソッド
    fileprivate func setupCellInitialSetting() {
        self.accessoryType  = UITableViewCellAccessoryType.none
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
}
