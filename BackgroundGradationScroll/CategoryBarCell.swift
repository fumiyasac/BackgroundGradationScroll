//
//  CategoryBarCell.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/16.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class CategoryBarCell: UICollectionViewCell {

    //UIパーツの配置
    @IBOutlet weak var categoryBarName: UILabel!

    var categoryIndex: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //セルの幅と高さを返すクラスメソッド（配置したUICollectionViewのセルの高さを合わせておく必要がある）
    class func cellOfSize() -> CGSize {
        let width = UIScreen.main.bounds.width / 3
        let height = CGFloat(50)
        return CGSize(width: width, height: height)
    }

}
