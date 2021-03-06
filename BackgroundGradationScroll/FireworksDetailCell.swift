//
//  RestaurantDetailCell.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/05.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class FireworksDetailCell: UITableViewCell {

    //UIパーツの配置
    @IBOutlet weak var fireworksWrappedView: UIView!
    @IBOutlet weak var fireworksDetailText: UITextView!
    @IBOutlet weak var fireworksDetailToggleButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellInitialSetting()
    }

    //詳細部分開閉用のボタンアクション
    @IBAction func fireworksDetailToggleAction(_ sender: UIButton) {
    }

    //セルの初期設定に関するメソッド
    fileprivate func setupCellInitialSetting() {
        self.accessoryType  = UITableViewCellAccessoryType.none
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
}
