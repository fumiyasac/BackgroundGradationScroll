//
//  ViewController.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/01.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

//パララックスに関するセッティング
struct Settings {
    static let parallaxRatio: CGFloat = 0.24
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //グラデーションレイヤーを作成
    fileprivate let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    //UIパーツの配置
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var restaurantTableView: UITableView!
    
    //AutoLayoutの制約
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomImageConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //グラデーションのセットアップ
        setupBackgroundGradation()
        
        //テーブルビューのセットアップ
        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self
        restaurantTableView.rowHeight = 240
        
        //Xibのセットアップ
        let nibTableView: UINib = UINib(nibName: "RestaurantCell", bundle: nil)
        restaurantTableView.register(nibTableView, forCellReuseIdentifier: "RestaurantCell")
    }

    /* (UITableViewDelegate) */
    
    //テーブルのセクションのセル数を設定する
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    /* (UITableViewDataSource) */

    //表示するセルの中身を設定する
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as? RestaurantCell
        
        //仮のデータを設計してセルに表示させる
        cell?.restaurantName.text = "Mexican Dinning"
        cell?.restaurantThumbnail.image = UIImage(named: "sample")
        cell?.restaurantOpen.text = "11:30 ~ 23:00"
        cell?.restaurantLunchTime.text = "Lunch 11:30 ~ 14:00"
        cell?.restaurantDetail.text = "このお店はタコスが絶品です。本場のタコスとテキーラで仕事帰りやランチタイムで最高の気分を味わって見ましょう！"

        cell?.accessoryType = UITableViewCellAccessoryType.none
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    //スクロールが検知された時に実行される処理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //パララックスをするテーブルビューの場合
        if scrollView == restaurantTableView {

            //スクロール終了時のy座標を取得する
            let currentPoint = scrollView.contentOffset

            //TEMPORARY: Y軸方向がマイナスの場合には背景画像がバウンズするように制約を変更
            if currentPoint.y < 0 {
                topImageConstraint.constant = -currentPoint.y * Settings.parallaxRatio
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //グラデーションの設定メソッド
    fileprivate func setupBackgroundGradation() {

        //上部分のグラデーションの開始色
        let topColor = ColorConverter.colorWithHexString(hex: "999999", alpha: 0.55).cgColor
        
        //下部分のグラデーションの開始色
        let bottomColor = ColorConverter.colorWithHexString(hex: "000000", alpha: 0.75).cgColor
        
        //グラデーションの色を配列で管理
        let gradientColors: [CGColor] = [topColor, bottomColor]
        
        //グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = gradientColors
        
        //グラデーションレイヤーを下に敷いたImageViewと同じにする
        gradientLayer.frame = backgroundImageView.frame
        
        //グラデーションレイヤーをビューの一番下に配置
        backgroundImageView.layer.insertSublayer(gradientLayer, at: 0)
    }

}

