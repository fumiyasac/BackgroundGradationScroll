//
//  RestaurantDetailCell.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/05.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class RestaurantDetailCell: UITableViewCell {

    //UIパーツの配置
    @IBOutlet weak var restaurantTitleLabel: UILabel!
    @IBOutlet weak var restaurantWrappedView: UIView!
    @IBOutlet weak var restaurantDetailText: UITextView!
    @IBOutlet weak var restaurantDetailToggleButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //詳細部分開閉用のボタンアクション
    @IBAction func restaurantDetailToggleAction(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
