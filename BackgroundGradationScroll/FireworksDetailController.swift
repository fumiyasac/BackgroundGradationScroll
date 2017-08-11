//
//  RestaurantDetailController.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/05.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

/**
 * ヘッダーのバウンスに関する実装参考
 * http://blog.matthewcheok.com/design-teardown-stretchy-headers/
 */

class FireworksDetailController: UITableViewController {
    
    //ヘッダー内に設定したイメージビュー
    var firstDisplayImage: UIImage? = nil

    //
    fileprivate let buttonTitleList: [String] = [
        "イメージ画像1",
        "イメージ画像2",
        "イメージ画像3",
        "イメージ画像4",
        "イメージ画像5",
        "イメージ画像6",
    ]

    //
    fileprivate let buttonSeparateValue = 3
    fileprivate let buttonFont = UIFont(name: "Georgia-Bold", size: 11)!

    //バウンドするヘッダーを作成するためのメンバ変数
    fileprivate var headerView: UIView!
    fileprivate let kTableHeaderHeight: CGFloat = 280.0

    //ギャラリー用の
    @IBOutlet weak var targetHeaderImageView: UIImageView!

    //ヘッダー下部分にあるスクロールビュー
    @IBOutlet weak var targetHeaderScrollView: UIScrollView!

    //スクロール内の動くラベルに関する設定
    fileprivate let movingLabel = UILabel()
    fileprivate let movingLabelY = 34
    fileprivate let movingLabelH = 1
    
    //ボタンスクロール時の移動量
    fileprivate var scrollButtonOffsetX: Int!

    //ギャラリーコンテンツ用のScrollViewを初期化
    fileprivate lazy var setupHeaderScrollViewLayout: (() -> ())? = {
        self.setupHeaderScrollViewProperties()
        self.setupHeaderScrollViewContentSize()
        self.setupButtonsInHeaderScrollView()
        return nil
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UITableViewのセルの高さに関する定義をする
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100000

        //バウンドするヘッダー部分の定義をする
        //targetHeaderView = tableView.tableHeaderView
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)

        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateTableViewHeader()

        //ヘッダー内に設定したイメージビューにGestureRecognizerをつける
        targetHeaderImageView.image = firstDisplayImage
    }

    //レイアウト処理が完了した際のライフサイクル
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //
        setupHeaderScrollViewLayout?()
    }

    /* MARK: - UITableViewDataSource - */

    //セクション数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //セクション内のセル数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var targerCell: UITableViewCell?
        
        //TODO: セルをそれぞれのセクションごとに作成する
        switch indexPath.row {
        case 0:
            targerCell = tableView.dequeueReusableCustomCell(with: FireworksDetailCell.self)
        case 1:
            targerCell = tableView.dequeueReusableCustomCell(with: MoreInfoCell.self)
        case 2:
            targerCell = tableView.dequeueReusableCustomCell(with: LinkInfoCell.self)
        default:
            fatalError()
        }

        targerCell?.accessoryType = UITableViewCellAccessoryType.none
        targerCell?.selectionStyle = UITableViewCellSelectionStyle.none
        return targerCell!
    }

    /* MARK: - UIScrollViewDelegate - */

    //スクロールが検知された時に実行される処理
    //参考: http://qiita.com/KatagiriSo/items/323c23e49dc49165b43c
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //ヘッダー下部分にあるスクロールビューの場合とそうでない場合で処理を分ける
        if scrollView != targetHeaderScrollView {

            //ヘッダーをスクロールに応じて動かす
            updateTableViewHeader()
        }
    }

    /* MARK: - @IBAction - */

    //閉じるボタン「×」をタップした際に行われる処理
    @IBAction func closeButtonAction(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    /* MARK: - addTarget Functions - */

    //ボタンをタップした際に行われる処理
    func scrollButtonTapped(button: UIButton) {
        
        //押されたボタンのタグを取得
        let index: Int = button.tag
        
        //コンテンツを押されたボタンに応じて移動する
        moveToCurrentButtonLabelButtonTapped(index: index)
        moveToButtonContentsScrollView(index: index)

        //TODO: タグの値に応じてアクションを定義する
    }
    
    /* MARK: - Fileprivate Functions - */

    //スクロールビュー内へのボタン配置に関する設定をする
    fileprivate func setupButtonsInHeaderScrollView() {

        //メインのスクロールビューの中にコンテンツ表示用のコンテナを一列に並べて配置する
        for buttonTitleIndex in (0 ..< buttonTitleList.count) {
            
            //メニュー用のスクロールビューにボタンを配置する
            setupButtonInHeaderScrollView(buttonTitle: buttonTitleList[buttonTitleIndex], index: buttonTitleIndex)

            //動くラベルを初期位置(0番目のボタン)に配置する
            if buttonTitleIndex == 0 {
                setupMovingLabelInHeaderScrollView()
            }
        }
    }

    //スクロールビュー内へのボタン配置に関する設定をする
    fileprivate func setupButtonInHeaderScrollView(buttonTitle: String, index: Int) {
        let buttonElement: UIButton = UIButton()
        buttonElement.frame = CGRect(
            x: CGFloat(DeviceSize.screenWidthToInt() / buttonSeparateValue * index),
            y: 0,
            width: CGFloat(DeviceSize.screenWidthToInt() / 3),
            height: targetHeaderScrollView.frame.height
        )
        buttonElement.backgroundColor = UIColor.clear
        buttonElement.setTitle(buttonTitle, for: UIControlState())
        buttonElement.setTitleColor(UIColor.white, for: UIControlState())
        buttonElement.titleLabel!.font = buttonFont
        buttonElement.tag = index
        buttonElement.addTarget(self, action: #selector(self.scrollButtonTapped(button:)), for: .touchUpInside)
        targetHeaderScrollView.addSubview(buttonElement)
    }

    //スクロールビュー内への動くラベルに関するを設定をする
    fileprivate func setupMovingLabelInHeaderScrollView() {

        //動くラベルをスクロールビュー内へ追加する
        targetHeaderScrollView.addSubview(movingLabel)
        targetHeaderScrollView.bringSubview(toFront: movingLabel)
        movingLabel.backgroundColor = UIColor.white

        //動くラベルの初期配置をする
        setMovingLabelPosition()
    }
    
    //スクロールビュー内のサイズを設定する
    fileprivate func setupHeaderScrollViewContentSize() {
        targetHeaderScrollView.contentSize = CGSize(
            width: CGFloat(DeviceSize.screenWidthToInt() / buttonSeparateValue * buttonTitleList.count),
            height: targetHeaderScrollView.frame.height
        )
    }

    //スクロールビュー内の各プロパティ値を設定する
    fileprivate func setupHeaderScrollViewProperties() {
        targetHeaderScrollView.isPagingEnabled = false
        targetHeaderScrollView.isScrollEnabled = true
        targetHeaderScrollView.isDirectionalLockEnabled = false
        targetHeaderScrollView.showsHorizontalScrollIndicator = false
        targetHeaderScrollView.showsVerticalScrollIndicator = false
        targetHeaderScrollView.bounces = true
        targetHeaderScrollView.scrollsToTop = false
    }

    //テーブルビューヘッダーの位置をスクロール量に合わせて変化させる
    fileprivate func updateTableViewHeader() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.frame.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }

    //ボタンのスクロールビューをスライドさせる
    fileprivate func moveToButtonContentsScrollView(index: Int) {
        
        //Case1: ボタンを内包しているスクロールビューの位置変更をする
        if index > 0 && index < (buttonTitleList.count - 1) {
            
            scrollButtonOffsetX = Int(targetHeaderScrollView.frame.width) / 3 * (index - 1)
            
        //Case2: 一番最初のpage番号のときの移動量
        } else if index == 0 {
            
            scrollButtonOffsetX = 0
            
        //Case3: 一番最後のpage番号のときの移動量 ※(page % 分割数 + 1 = 分割数)の場合
        } else if index == (buttonTitleList.count - 1) && index % buttonSeparateValue == buttonSeparateValue - 1 {
            
            scrollButtonOffsetX = Int(targetHeaderScrollView.frame.width) * (buttonTitleList.count / 3 - 1)

        //Case4: 一番最後のpage番号のときの移動量 ※(page % 分割数 + 1 ≠ 分割数)の場合
        } else if index == (buttonTitleList.count - 1) && index % 3 != 2 {

            scrollButtonOffsetX = Int(targetHeaderScrollView.frame.width) / 3 * (index - 2)
        }

        UIView.animate(withDuration: 0.26, delay: 0, options: [], animations: {
            self.targetHeaderScrollView.contentOffset = CGPoint(
                x: self.scrollButtonOffsetX,
                y: 0
            )
        }, completion: nil)
    }

    //ボタンタップ時に動くラベルをスライドさせる
    fileprivate func moveToCurrentButtonLabelButtonTapped(index: Int) {
        UIView.animate(withDuration: 0.26, delay: 0, options: [], animations: {
            self.setMovingLabelPosition(index: index)
        })
    }

    //
    fileprivate func setMovingLabelPosition(index: Int = 0) {

        //ボタンのテキスト幅を取得する
        let buttonTextWidth = getCharacterWidthValue(
            string: buttonTitleList[index],
            font: buttonFont
        )
        
        //動くラベルのScrollView内でのX座標を取得する
        let positionX = getMovingLabelPosX(
            scrollViewLayoutWidth: DeviceSize.screenWidthToInt(),
            separateValue: buttonSeparateValue,
            index: index,
            charWidth: buttonTextWidth
        )
        
        //アニメーションで動くラベル（下線）の初期位置を設定する
        movingLabel.frame = CGRect(
            x: positionX,
            y: movingLabelY,
            width: buttonTextWidth,
            height: movingLabelH
        )
    }
    
    //取得したテキスト文字列とフォントから文字列の幅を取得する
    fileprivate func getCharacterWidthValue(string: String, font: UIFont) -> Int {
        let size = string.size(attributes: [NSFontAttributeName : font])
        return Int(size.width)
    }
    
    //ボタン表示テキストとスクロールビューの表示エリアから動くラベル（下線）のX座標を取得する
    /**
     * 引数は下記の通り：
     * scrollViewLayoutWidth(Int型) : ボタンを入れたスクロールビューの幅
     * separateValue(Int型)         : ボタンを入れたスクロールビューの幅で表示されるボタンの数
     * page(Int型)                  : 現在のページ番号(0..n)
     * charWidth(Int型)             : ボタンに表示している文字の幅
     */
    fileprivate func getMovingLabelPosX(scrollViewLayoutWidth: Int, separateValue: Int, index: Int, charWidth: Int) -> Int {
        
        /**
         * 下記のような計算式で位置を算出する：
         * ★ (動くラベルのX座標位置) = (ボタンを入れたスクロールビューの幅 ÷ ボタン数 ÷ 2) + (ボタンを入れたスクロールビューの幅 ÷ 分割数 × 現在のページ番号) - (ボタンに表示している文字の幅 ÷ 2)
         */
        let positionX: Int = Int(scrollViewLayoutWidth / separateValue / 2) + Int(Int(scrollViewLayoutWidth / 3) * index) - Int(charWidth / 2)
        return positionX
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension FireworksDetailController: StoryboardInstantiatable {

    //
    static var storyboardName: String {
        return "Detail"
    }

    //
    static var viewControllerIdentifier: String? {
        return "FireworksDetailController"
    }
}

