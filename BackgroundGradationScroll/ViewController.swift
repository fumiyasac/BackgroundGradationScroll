//
//  ViewController.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/01.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //サイドバーのステータス
    fileprivate enum SidebarStatus {
        case opened
        case closed
    }

    //コンテンツ用テーブルビューのステータス
    fileprivate enum SectionStatus: Int {
        case slider
        case fireworks
    }

    //サイドバーの表示幅の値
    fileprivate let SIDEBAR_WIDTH: CGFloat = 260.0
    
    //パララックス値の移動値
    fileprivate let PARALLAX_RATIO: CGFloat = 0.24

    //サイドバーのステータス値
    fileprivate var sidebarStatus: SidebarStatus = .closed

    //グラデーションレイヤーを作成
    fileprivate let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    //ヘッダー用ビューの作成
    fileprivate var headerBackgroundView: UIView = UIView(
        frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64)
    )

    //UIパーツの配置
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var fireworksTableView: UITableView!    
    @IBOutlet weak var sideMenuHandleButton: UIButton!
    @IBOutlet weak var sideMenuContainerView: UIView!
    
    //カスタムトランジション用クラスのインスタンス
    fileprivate let transition = FireworksDetailTransition()

    override func viewDidLoad() {
        super.viewDidLoad()

        //UIに関する初期設定のセットアップを行う
        setupHeaderView()
        setupBackgroundGradation()
        setupFireworksTableView()

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
        sideMenuHandleButton.frame     = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        sideMenuHandleButton.isEnabled = false
        sideMenuHandleButton.alpha     = 0
        sideMenuContainerView.frame    = CGRect(x: -SIDEBAR_WIDTH, y: 0, width: SIDEBAR_WIDTH, height: self.view.frame.height)

        navigationController?.view.addSubview(sideMenuHandleButton)
        navigationController?.view.addSubview(sideMenuContainerView)
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
        let columnViewController = ColumnViewController.instantiate()
        self.navigationController?.pushViewController(columnViewController, animated: true)
    }

    /* MARK: - Fileprivate Functions - */

    //サイドメニューの開閉ハンドリング機能を実装する
    fileprivate func changeSideMenuStatus(_ targetStatus: SidebarStatus) {
        
        if targetStatus == SidebarStatus.opened {

            //サイドメニューを表示状態にする
            UIView.animate(withDuration: 0.26, delay: 0, options: .curveEaseOut, animations: {
                self.sideMenuHandleButton.isEnabled = true
                self.sideMenuHandleButton.alpha     = 0.75
                self.sideMenuContainerView.alpha    = 1.00
                self.sideMenuContainerView.frame    = CGRect(x: 0, y: 0, width: self.SIDEBAR_WIDTH, height: self.view.frame.height)
            }, completion: nil)

        } else {

            //サイドメニューを非表示状態にする
            UIView.animate(withDuration: 0.26, delay: 0, options: .curveEaseOut, animations: {
                self.sideMenuHandleButton.isEnabled = false
                self.sideMenuHandleButton.alpha     = 0.00
                self.sideMenuContainerView.alpha    = 0.00
                self.sideMenuContainerView.frame    = CGRect(x: -self.SIDEBAR_WIDTH, y: 0, width: self.SIDEBAR_WIDTH, height: self.view.frame.height)
            }, completion: nil)
        }
    }

    //背景グラデーションの初期化を行う
    fileprivate func setupBackgroundGradation() {

        //グラデーションの色を配列で管理（上部分 & 下部分）
        let gradientColors: [CGColor] = [
            ColorConverter.colorWithHexString(hex: "666666", alpha: 0.35).cgColor,
            ColorConverter.colorWithHexString(hex: "000000", alpha: 0.75).cgColor
        ]

        //グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = gradientColors

        //グラデーションレイヤーを下に敷いたImageViewと同じにする
        gradientLayer.frame = backgroundImageView.frame

        //グラデーションレイヤーをビューの一番下に配置
        backgroundImageView.layer.insertSublayer(gradientLayer, at: 0)
    }

    //テーブルビューの初期化を行う
    fileprivate func setupFireworksTableView() {
        fireworksTableView.delegate   = self
        fireworksTableView.dataSource = self
        fireworksTableView.rowHeight  = 309.5
        fireworksTableView.registerCustomCell(FireworksCell.self)
    }
    
    //ヘッダービューの初期化を行う
    fileprivate func setupHeaderView() {

        //背景の配色や線に関する設定を行う
        headerBackgroundView.backgroundColor = ColorConverter.colorWithHexString(hex: "333333", alpha: 0.85)
        self.view.addSubview(headerBackgroundView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDelegate, UIScrollViewDelegate {
    
    /* MARK: - UITableViewDelegate - */

    //セルを表示しようとする時の動作を設定する
    /**
     * willDisplay(UITableViewDelegateのメソッド)に関して
     *
     * 参考: Cocoa API解説(macOS/iOS) tableView:willDisplayCell:forRowAtIndexPath:
     * https://goo.gl/Ykp30Q
     */
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        //FireworksCell型へダウンキャストする
        let imageCell = cell as! FireworksCell
        
        //セル内の画像のオフセット値を変更する
        setCellImageOffset(imageCell, indexPath: indexPath)
        
        //セルへフェードインのCoreAnimationを適用する
        setCellFadeInAnimation(imageCell)
    }

    /* MARK: - UIScrollViewDelegate - */
    
    //スクロールが検知された時に実行される処理
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //パララックスをするテーブルビューの場合
        if scrollView == fireworksTableView {
            
            //画面に表示されているセルの画像のオフセット値を変更する
            for indexPath in fireworksTableView.indexPathsForVisibleRows! {
                setCellImageOffset(fireworksTableView.cellForRow(at: indexPath) as! FireworksCell, indexPath: indexPath)
            }
        }
    }
    
    //UITableViewCell内のオフセット値を再計算して視差効果をつける
    private func setCellImageOffset(_ cell: FireworksCell, indexPath: IndexPath) {
        
        //TODO: 計算ロジックをコメントで残す
        let cellFrame = fireworksTableView.rectForRow(at: indexPath)
        let cellFrameInTable = fireworksTableView.convert(cellFrame, to: fireworksTableView.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = fireworksTableView.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight

        cell.setBackgroundOffset(cellOffsetFactor)
    }
    
    //UITableViewCellが表示されるタイミングにフェードインのアニメーションをつける
    private func setCellFadeInAnimation(_ cell: FireworksCell) {
        
        /**
         * CoreAnimationを利用したアニメーションをセルの表示時に付与する（拡大とアルファの重ねがけ）
         *
         * 参考:【iOS Swift入門 #185】Core Animationでアニメーションの加速・減速をする
         * http://swift-studying.com/blog/swift/?p=1162
         */
        
        //アニメーションの作成
        let groupAnimation            = CAAnimationGroup()
        groupAnimation.fillMode       = kCAFillModeBackwards
        groupAnimation.duration       = 0.36
        groupAnimation.beginTime      = CACurrentMediaTime() + 0.08
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        //透過を変更するアニメーション
        let opacityAnimation       = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.00
        opacityAnimation.toValue   = 1.00
        
        //作成した個別のアニメーションをグループ化
        groupAnimation.animations = [opacityAnimation]
        
        //セルのLayerにアニメーションを追加
        cell.layer.add(groupAnimation, forKey: nil)
        
        //アニメーション終了後は元のサイズになるようにする
        cell.layer.transform = CATransform3DIdentity
    }
}

extension ViewController: UITableViewDataSource {

    /* MARK: - UITableViewDataSource - */

    //テーブルのセクション数を設定する
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //テーブルのセクションのセル数を設定する
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    //表示するセルの中身を設定する
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCustomCell(with: FireworksCell.self)
        
        //TODO: 取得データをセルに表示させる
        
        //セル内に配置したボタンを押下した際に発動されるアクションの内容を入れる
        cell.showFireworksDetailClosure = {
            
            //遷移先のViewControllerの設定を行う
            let fireworksDetailController = FireworksDetailController.instantiate()
            
            //遷移先のヘッダー画像に遷移元の画像を設定してカスタムトランジションを利用して遷移する
            fireworksDetailController.firstDisplayImage     = cell.imageImplView.image
            fireworksDetailController.transitioningDelegate = self
            
            self.present(fireworksDetailController, animated: true, completion: nil)
        }
        
        cell.accessoryType  = UITableViewCellAccessoryType.none
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {

    /* MARK: - UIViewControllerTransitioningDelegate - */
    
    //進む場合のアニメーションの設定を行う
    internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //選択したサムネイル画像の位置とサイズの情報を引き渡す
        transition.originalFrame = self.view.frame
        transition.presenting    = true
        return transition
    }
    
    //戻る場合のアニメーションの設定を行う
    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.presenting = false
        return transition
    }

}
