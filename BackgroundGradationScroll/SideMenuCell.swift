//
//  SideMenuCell.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/02/03.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    //UIパーツの配置
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var menuNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
