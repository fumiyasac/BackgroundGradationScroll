//
//  ViewController.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/01.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    //サイドバーのステータス
    enum SidebarStatus {
        case opened
        case closed
    }

    //サイドバーの表示幅の値
    fileprivate let SIDEBAR_WIDTH: CGFloat = 260.0
    
    //パララックス値の移動値
    fileprivate var PARALLAX_RATIO: CGFloat = 0.24

    //サイドバーのステータス値
    fileprivate var sidebarStatus: SidebarStatus = .closed

    //グラデーションレイヤーを作成
    fileprivate let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    //ダミーヘッダービューの作成
    fileprivate var headerBackgroundView: UIView = UIView(
        frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64)
    )

    //UIパーツの配置
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var restaurantTableView: UITableView!
    @IBOutlet weak var sideMenuHandleButton: UIButton!
    @IBOutlet weak var sideMenuContainerView: UIView!
    
    //カスタムトランジション用クラスのインスタンス
    let transition = RestaurantDetailTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ダミーヘッダービューのセットアップ
        initializeDummyHeaderView()
        
        //グラデーションのセットアップ
        setupBackgroundGradation()

        //テーブルビューのセットアップ
        initializeRestaurantTableView()
        
        //サイドメニューバーの初期状態のセットアップ
        changeSideMenuStatus(sidebarStatus)
    }
    
    /* MARK: - viewWillAppear - */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //NavigationControllerのカスタマイズを行う(ナビゲーションを透明にする)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.tintColor = UIColor.white
    }

    /* MARK: - viewDidLayoutSubviews - */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //サイドメニューの初期位置設定と配置を行う
        sideMenuHandleButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        sideMenuHandleButton.isEnabled = false
        sideMenuHandleButton.alpha = 0
        sideMenuContainerView.frame = CGRect(x: -SIDEBAR_WIDTH, y: 0, width: SIDEBAR_WIDTH, height: self.view.frame.height)
        
        navigationController?.view.addSubview(sideMenuHandleButton)
        navigationController?.view.addSubview(sideMenuContainerView)
    }

    /* MARK: - UITableViewDelegate - */
    
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

        //セル内の画像のオフセット値を変更する
        setCellImageOffset(imageCell, indexPath: indexPath)

        //セルへフェードインのCoreAnimationを適用する
        setCellFadeInAnimation(imageCell)
    }

    /* MARK: - UITableViewDataSource - */

    //表示するセルの中身を設定する
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as? RestaurantCell
        
        //TODO: 取得データをセルに表示させる

        //セル内に配置したボタンを押下した際に発動されるアクションの内容を入れる
        cell?.showRestaurantDetailClosure = {

            //遷移先のViewControllerの設定を行う
            let restaurantDetail = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RestaurantDetailController") as! RestaurantDetailController

            //遷移先のヘッダー画像に遷移元の画像を設定してカスタムトランジションを利用して遷移する
            restaurantDetail.firstDisplayImage = cell?.imageImplView.image
            restaurantDetail.transitioningDelegate = self

            self.present(restaurantDetail, animated: true, completion: nil)
        }

        cell?.accessoryType = UITableViewCellAccessoryType.none
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }

    /* MARK: - UIScrollViewDelegate - */

    //スクロールが検知された時に実行される処理
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //パララックスをするテーブルビューの場合
        if scrollView == restaurantTableView {

            //画面に表示されているセルの画像のオフセット値を変更する
            for indexPath in restaurantTableView.indexPathsForVisibleRows! {
                setCellImageOffset(restaurantTableView.cellForRow(at: indexPath) as! RestaurantCell, indexPath: indexPath)
            }
        }
    }
    
    /* MARK: - UIViewControllerTransitioningDelegate - */
    
    //進む場合のアニメーションの設定を行う
    internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //選択したサムネイル画像の位置とサイズの情報を引き渡す
        transition.originalFrame = self.view.frame
        transition.presenting = true
        return transition
    }
    
    //戻る場合のアニメーションの設定を行う
    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.presenting = false
        return transition
    }

    /* MARK: - IBActions - */

    //サイドメニューを開くためのアクション
    @IBAction func openSideMenuAction(_ sender: UIButton) {
        sidebarStatus = .opened
        changeSideMenuStatus(sidebarStatus)
    }

    //サイドメニューを閉じるためのアクション
    @IBAction func closeSideMenuAction(_ sender: UIButton) {
        sidebarStatus = .closed
        changeSideMenuStatus(sidebarStatus)
    }

    //コラム用コンテンツを開くアクション
    @IBAction func openColumnContentsAction(_ sender: UIButton) {
        
        //Column.storyboard側のコンテンツを表示する
        let columnView = UIStoryboard(name: "Column", bundle: nil).instantiateViewController(withIdentifier: "ColumnViewController") as! ColumnViewController
        self.navigationController?.pushViewController(columnView, animated: true)
    }

    /* MARK: - Fileprivate Functions - */

    //サイドメニューの開閉ハンドリング機能を実装する
    fileprivate func changeSideMenuStatus(_ targetStatus: SidebarStatus) {
        
        if targetStatus == SidebarStatus.opened {
            
            //サイドメニューを表示状態にする
            UIView.animate(withDuration: 0.26, delay: 0, options: .curveEaseOut, animations: {
                
                self.sideMenuHandleButton.isEnabled = true
                self.sideMenuHandleButton.alpha = 0.75
                self.sideMenuContainerView.frame = CGRect(x: 0, y: 0, width: self.SIDEBAR_WIDTH, height: self.view.frame.height)
                self.sideMenuContainerView.alpha = 1.00
                
            }, completion: nil)
            
        } else {
            
            //サイドメニューを非表示状態にする
            UIView.animate(withDuration: 0.26, delay: 0, options: .curveEaseOut, animations: {
                
                self.sideMenuHandleButton.isEnabled = false
                self.sideMenuHandleButton.alpha = 0.00
                self.sideMenuContainerView.frame = CGRect(x: -self.SIDEBAR_WIDTH, y: 0, width: self.SIDEBAR_WIDTH, height: self.view.frame.height)
                self.sideMenuContainerView.alpha = 0.00

            }, completion: nil)
        }
    }
    
    //UITableViewCell内のオフセット値を再計算して視差効果をつける
    fileprivate func setCellImageOffset(_ cell: RestaurantCell, indexPath: IndexPath) {
        
        //TODO: 計算ロジックをコメントで残す
        let cellFrame = restaurantTableView.rectForRow(at: indexPath)
        let cellFrameInTable = restaurantTableView.convert(cellFrame, to: restaurantTableView.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = restaurantTableView.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight

        cell.setBackgroundOffset(cellOffsetFactor)
    }

    //UITableViewCellが表示されるタイミングにフェードインのアニメーションをつける
    fileprivate func setCellFadeInAnimation(_ cell: RestaurantCell) {
 
        /**
         * CoreAnimationを利用したアニメーションをセルの表示時に付与する（拡大とアルファの重ねがけ）
         *
         * 参考:【iOS Swift入門 #185】Core Animationでアニメーションの加速・減速をする
         * http://swift-studying.com/blog/swift/?p=1162
         */

        //アニメーションの作成
        let groupAnimation = CAAnimationGroup()
        groupAnimation.fillMode = kCAFillModeBackwards
        groupAnimation.duration = 0.36
        groupAnimation.beginTime = CACurrentMediaTime() + 0.08
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        //透過を変更するアニメーション
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.00
        opacityAnimation.toValue   = 1.00
        
        //作成した個別のアニメーションをグループ化
        groupAnimation.animations = [opacityAnimation]
        
        //セルのLayerにアニメーションを追加
        cell.layer.add(groupAnimation, forKey: nil)
        
        //アニメーション終了後は元のサイズになるようにする
        cell.layer.transform = CATransform3DIdentity
    }

    //グラデーションの設定メソッド
    fileprivate func setupBackgroundGradation() {

        //上部分のグラデーションの開始色 ＆ 下部分のグラデーションの開始色
        let topColor = ColorConverter.colorWithHexString(hex: "666666", alpha: 0.35).cgColor
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

    //レストランデータのテーブルビューの初期化を行う
    fileprivate func initializeRestaurantTableView() {

        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self
        restaurantTableView.rowHeight = 309.5

        let nibTableView: UINib = UINib(nibName: "RestaurantCell", bundle: nil)
        restaurantTableView.register(nibTableView, forCellReuseIdentifier: "RestaurantCell")
    }
    
    //ダミー用のヘッダービューの内容を設定する
    fileprivate func initializeDummyHeaderView() {

        //背景の配色や線に関する設定を行う
        headerBackgroundView.backgroundColor = ColorConverter.colorWithHexString(hex: "333333", alpha: 0.85)
        self.view.addSubview(headerBackgroundView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
