//
//  RestaurantCell.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/01.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

    //ViewController.swiftへ処理内容を引き渡すためのクロージャーを設定
    var showRestaurantDetailClosure: (() -> ())?
    
    //UIパーツの配置
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var imageWrapView: UIView!
    @IBOutlet weak var imageImplView: UIImageView!
    @IBOutlet weak var recommendPointLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    //UIViewに内包したUIImageViewの上下の制約
    @IBOutlet weak var topImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomImageViewConstraint: NSLayoutConstraint!

    //視差効果のズレを生むための定数（大きいほど視差効果が大きい）
    let imageParallaxFactor: CGFloat = 75
    
    //視差効果の計算用の変数
    var imgBackTopInitial: CGFloat!
    var imgBackBottomInitial: CGFloat!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //意図的にずらした値を視差効果の計算用の変数にそれぞれ格納する
        clipsToBounds = true
        bottomImageViewConstraint.constant -= 2 * imageParallaxFactor
        imgBackTopInitial = topImageViewConstraint.constant
        imgBackBottomInitial = bottomImageViewConstraint.constant
        
        //外枠のUIViewに枠線を付与する
        imageWrapView.layer.borderWidth = 1
        imageWrapView.layer.borderColor = ColorConverter.colorWithHexString(hex: "dddddd", alpha: 0.75).cgColor
    }

    //背景画像にかけられているAutoLayoutの制約を再計算して制約をかけ直す
    func setBackgroundOffset(_ offset: CGFloat) {
        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1 - boundOffset) * 2 * imageParallaxFactor
        topImageViewConstraint.constant = imgBackTopInitial - pixelOffset
        bottomImageViewConstraint.constant = imgBackBottomInitial + pixelOffset
    }
    
    //詳細画面へ遷移するためのアクション
    @IBAction func showDetailAction(_ sender: UIButton) {

        //クロージャーの実行を行う(UITableView配置側で処理の実体を記載する)
        showRestaurantDetailClosure!()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
