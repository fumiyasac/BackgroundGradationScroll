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
    }

    //「Hotpepperの情報を見る」ボタン押下時のアクション
    @IBAction func linkHotpepperAction(_ sender: UIButton) {
    }

    //「食べログの情報を見る」ボタン押下時のアクション
    @IBAction func linkTabelogAction(_ sender: UIButton) {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
