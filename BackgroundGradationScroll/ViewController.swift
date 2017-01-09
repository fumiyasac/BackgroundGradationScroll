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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //グラデーションのセットアップ
        setupBackgroundGradation()
        
        //テーブルビューのセットアップ
        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self
        restaurantTableView.rowHeight = 278
        
        //Xibのセットアップ
        let nibTableView: UINib = UINib(nibName: "RestaurantCell", bundle: nil)
        restaurantTableView.register(nibTableView, forCellReuseIdentifier: "RestaurantCell")
    }

    /* (UITableViewDelegate) */
    
    //テーブルのセクションのセル数を設定する
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    //セルを表示しようとする時の動作を設定する
    /**
     * willDisplay(UITableViewDelegateのメソッド)に関して
     *
     * 参考: Cocoa API解説(macOS/iOS) tableView:willDisplayCell:forRowAtIndexPath:
     * https://goo.gl/Ykp30Q
     */
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let imageCell = cell as! RestaurantCell
        setCellImageOffset(imageCell, indexPath: indexPath)
        
        /**
         * CoreAnimationを利用したアニメーションをセルの表示時に付与する（拡大とアルファの重ねがけ）
         *
         * 参考:【iOS Swift入門 #185】Core Animationでアニメーションの加速・減速をする
         * http://swift-studying.com/blog/swift/?p=1162
         */

        //アニメーションの作成
        let groupAnimation = CAAnimationGroup()
        groupAnimation.fillMode = kCAFillModeBackwards
        groupAnimation.duration = 0.16
        groupAnimation.beginTime = CACurrentMediaTime() + 0.08
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        //透過を変更するアニメーション
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.0
        opacityAnimation.toValue = 1.0
         
        //作成した個別のアニメーションをグループ化
        groupAnimation.animations = [opacityAnimation]
         
        //セルのLayerにアニメーションを追加
        cell.layer.add(groupAnimation, forKey: nil)
         
        //アニメーション終了後は元のサイズになるようにする
        cell.layer.transform = CATransform3DIdentity
    }

    /* (UITableViewDataSource) */

    //表示するセルの中身を設定する
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as? RestaurantCell
        
        //仮のデータを設計してセルに表示させる
        //cell?.restaurantName.text = "Mexican Dinning"
        //cell?.restaurantThumbnail.image = UIImage(named: "sample")
        //cell?.restaurantOpen.text = "11:30 ~ 23:00"
        //cell?.restaurantLunchTime.text = "Lunch 11:30 ~ 14:00"
        //cell?.restaurantDetail.text = "このお店はタコスが絶品です。本場のタコスとテキーラで仕事帰りやランチタイムで最高の気分を味わって見ましょう！"

        cell?.accessoryType = UITableViewCellAccessoryType.none
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }

    /* (UIScrollViewDelegate) */

    //スクロールが検知された時に実行される処理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //パララックスをするテーブルビューの場合
        if scrollView == restaurantTableView {

            //画面に表示されているセルの画像のオフセット値を変更する
            for indexPath in restaurantTableView.indexPathsForVisibleRows! {
                setCellImageOffset(restaurantTableView.cellForRow(at: indexPath) as! RestaurantCell, indexPath: indexPath)
            }
        }
        
    }
    
    /* (Fileprivate Functions) */
    
    //UITableViewCell内のオフセット値を再計算して視差効果をつける
    fileprivate func setCellImageOffset(_ cell: RestaurantCell, indexPath: IndexPath) {
        
        let cellFrame = restaurantTableView.rectForRow(at: indexPath)
        let cellFrameInTable = restaurantTableView.convert(cellFrame, to: restaurantTableView.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = restaurantTableView.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight
        
        cell.setBackgroundOffset(cellOffsetFactor)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
