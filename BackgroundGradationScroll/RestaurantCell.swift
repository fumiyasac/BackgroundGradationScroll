//
//  RestaurantCell.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/01.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

    //UIパーツの配置
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantThumbnail: UIImageView!
    @IBOutlet weak var restaurantOpen: UILabel!
    @IBOutlet weak var restaurantLunchTime: UILabel!
    @IBOutlet weak var restaurantDetail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
