//
//  MoreInfoCell.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/02/04.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit
import MapKit

class MoreInfoCell: UITableViewCell, CLLocationManagerDelegate, MKMapViewDelegate {

    //UIパーツの配置
    @IBOutlet weak var moreInfoBudgetIcon: UIImageView!
    @IBOutlet weak var moreInfoBudgetLabel: UILabel!
    @IBOutlet weak var moreInfoOpenIcon: UIImageView!
    @IBOutlet weak var moreInfoOpenLabel: UILabel!
    @IBOutlet weak var moreInfoGenreIcon: UIImageView!
    @IBOutlet weak var moreInfoGenreLabel: UILabel!
    @IBOutlet weak var moreInfoMapWrappedView: UIView!
    @IBOutlet weak var moreInfoMapView: MKMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        moreInfoMapView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
