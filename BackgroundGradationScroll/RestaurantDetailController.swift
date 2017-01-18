//
//  RestaurantDetailController.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/05.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

//ボタンに表示する文言のリスト(実際はデータからぶっこ抜く)
struct ScrollButtonList {
    static let buttonList: [String] = [
        "taco",
        "enchilada",
        "quesadilla",
        "pozole",
        "ceviche"
    ]
}

//スライドメニューの位置定義
struct SlideMenuSetting {
    static let movingLabelY = 40
    static let movingLabelH = 2
}

/**
 * ヘッダーのバウンスに関する実装参考
 * http://blog.matthewcheok.com/design-teardown-stretchy-headers/
 */

class RestaurantDetailController: UITableViewController {

    //バウンドするヘッダーを作成するためのメンバ変数
    fileprivate var headerView: UIView!
    fileprivate let kTableHeaderHeight: CGFloat = 280.0
    
    //ヘッダー内に設定したイメージビュー
    @IBOutlet weak var targetHeaderImageView: UIImageView!

    //ヘッダー下部分にあるスクロールビュー
    @IBOutlet weak var targetHeaderScrollView: UIScrollView!

    //スクロール内の動くラベル
    fileprivate let movingLabel = UILabel()

    //ボタンスクロール時の移動量
    fileprivate var scrollButtonOffsetX: Int!

    //レイアウトを一度だけ行うフラグ変数
    fileprivate var layoutOnceFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //バウンドするヘッダー部分の定義をする
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateTableViewHeader()

        //ヘッダー内に設定したイメージビューにGestureRecognizerをつける
        targetHeaderImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RestaurantDetailController.changeTargetHeaderImageView(sender:)))
        targetHeaderImageView.addGestureRecognizer(tapGesture)
    }

    //レイアウト処理が完了した際のライフサイクル
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //UIScrollViewへのボタン配置を行う（動くラベル付）
        //※AutoLayoutのConstraintを用いたアニメーションの際には動的に配置する見た目要素は一度だけ実行する
        if layoutOnceFlag == false {
            
            //コンテンツ用のScrollViewを初期化
            initScrollViewDefinition()
            
            //フォントの定義
            let fontSetting = UIFont(name: "Georgia-Bold", size: 12)!
            
            //スクロールビュー内のサイズを決定する（AutoLayoutで配置を行った場合でもこの部分はコードで設定しないといけない）
            targetHeaderScrollView.contentSize = CGSize(
                width: CGFloat(Int(targetHeaderScrollView.frame.width / 3) * ScrollButtonList.buttonList.count),
                height: targetHeaderScrollView.frame.height
            )
            
            //メインのスクロールビューの中にコンテンツ表示用のコンテナを一列に並べて配置する
            for i in 0...(ScrollButtonList.buttonList.count - 1) {
                
                //メニュー用のスクロールビューにボタンを配置
                let buttonElement: UIButton! = UIButton()
                targetHeaderScrollView.addSubview(buttonElement)
                
                buttonElement.frame = CGRect(
                    x: CGFloat(Int(targetHeaderScrollView.frame.width) / 3 * i),
                    y: 0,
                    width: targetHeaderScrollView.frame.width / 3,
                    height: targetHeaderScrollView.frame.height
                )
                buttonElement.backgroundColor = UIColor.clear
                buttonElement.setTitle(ScrollButtonList.buttonList[i], for: UIControlState())
                buttonElement.setTitleColor(UIColor.white, for: UIControlState())
                buttonElement.titleLabel!.font = fontSetting
                buttonElement.tag = i
                buttonElement.addTarget(self, action: #selector(RestaurantDetailController.scrollButtonTapped(button:)), for: .touchUpInside)
                
                //一番最初に配置されるタイミングで動くラベルを初期化（今回は画面遷移後の画面が動くラベルが左端にある時を想定している）
                if i == 0 {
                    
                    //動くラベルの配置
                    targetHeaderScrollView.addSubview(movingLabel)
                    targetHeaderScrollView.bringSubview(toFront: movingLabel)
                    movingLabel.backgroundColor = UIColor.white
                    
                    //ボタンのテキスト幅を取得する
                    let buttonTextWidth = getCharacterWidthValue(
                        string: ScrollButtonList.buttonList[i],
                        font: fontSetting
                    )
                    
                    //動くラベルのScrollView内でのX座標を取得する
                    let positionX = self.getMovingLabelPosX(
                        scrollViewLayoutWidth: Int(targetHeaderScrollView.frame.width),
                        separateValue: 3,
                        page: i,
                        charWidth: buttonTextWidth
                    )
                    
                    //アニメーションで動くラベル（下線）の初期位置を設定する
                    self.movingLabel.frame = CGRect(
                        x: positionX,
                        y: SlideMenuSetting.movingLabelY,
                        width: buttonTextWidth,
                        height: SlideMenuSetting.movingLabelH
                    )
                }
            }
            
            //一度だけ実行するフラグを有効化
            layoutOnceFlag = true
        }
    }
    
    //セクション数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //セクション内のセル数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TODO: セルをそれぞれのセクションごとに作成する
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailCell", for: indexPath)
        return cell
    }

    /* (UIScrollViewDelegate) */

    //スクロールが検知された時に実行される処理
    //参考: http://qiita.com/KatagiriSo/items/323c23e49dc49165b43c
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //ヘッダー下部分にあるスクロールビューの場合とそうでない場合で処理を分ける
        if scrollView != targetHeaderScrollView {

            //ヘッダーをスクロールに応じて動かす
            updateTableViewHeader()
            
        } else {
            
        }
    }

    /* (Functions) */
    
    //ヘッダーのイメージビューのGestureRecognizer発動時に呼ばれる
    func changeTargetHeaderImageView(sender: UITapGestureRecognizer) {
        print("Target Header ImageTapped.")
    }

    //ボタンをタップした際に行われる処理
    func scrollButtonTapped(button: UIButton) {
        
        //押されたボタンのタグを取得
        let page: Int = button.tag
        
        //コンテンツを押されたボタンに応じて移動する
        moveToCurrentButtonLabelButtonTapped(page: page)
        moveToButtonContentsScrollView(page: page)

        //TODO: タグの値に応じてアクションを定義する
    }
    
    /* (Fileprivate Functions) */
    
    //テーブルビューヘッダーの位置をスクロール量に合わせて変化させる
    fileprivate func updateTableViewHeader() {

        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.frame.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    //コンテンツ用のUIScrollViewの初期化を行う
    fileprivate func initScrollViewDefinition() {
        
        //スクロールビュー内の各プロパティ値を設定する
        targetHeaderScrollView.isPagingEnabled = false
        targetHeaderScrollView.isScrollEnabled = true
        targetHeaderScrollView.isDirectionalLockEnabled = false
        targetHeaderScrollView.showsHorizontalScrollIndicator = false
        targetHeaderScrollView.showsVerticalScrollIndicator = false
        targetHeaderScrollView.bounces = true
        targetHeaderScrollView.scrollsToTop = false
    }

    //ボタンのスクロールビューをスライドさせる
    fileprivate func moveToButtonContentsScrollView(page: Int) {
        
        //Case1: ボタンを内包しているスクロールビューの位置変更をする
        if page > 0 && page < (ScrollButtonList.buttonList.count - 1) {
            
            scrollButtonOffsetX = Int(targetHeaderScrollView.frame.width) / 3 * (page - 1)
            
        //Case2: 一番最初のpage番号のときの移動量
        } else if page == 0 {
            
            scrollButtonOffsetX = 0
            
        //Case3: 一番最後のpage番号のときの移動量 ※(page % 分割数 + 1 = 分割数)の場合
        } else if page == (ScrollButtonList.buttonList.count - 1) && page % 3 == 2 {
            
            scrollButtonOffsetX = Int(targetHeaderScrollView.frame.width) * (ScrollButtonList.buttonList.count / 3 - 1)

        //Case4: 一番最後のpage番号のときの移動量 ※(page % 分割数 + 1 ≠ 分割数)の場合
        } else if page == (ScrollButtonList.buttonList.count - 1) && page % 3 != 2 {

            scrollButtonOffsetX = Int(targetHeaderScrollView.frame.width) / 3 * (page - 2)
        }

        UIView.animate(withDuration: 0.26, delay: 0, options: [], animations: {
            self.targetHeaderScrollView.contentOffset = CGPoint(
                x: self.scrollButtonOffsetX,
                y: 0
            )
        }, completion: nil)
    }

    //ボタンタップ時に動くラベルをスライドさせる
    fileprivate func moveToCurrentButtonLabelButtonTapped(page: Int) {
        
        UIView.animate(withDuration: 0.26, delay: 0, options: [], animations: {
            
            //ボタンのテキスト幅を取得する
            let buttonTextWidth = self.getCharacterWidthValue(
                string: ScrollButtonList.buttonList[page],
                font: UIFont(name: "Georgia-Bold", size: 11)!
            )
            
            //動くラベルのScrollView内でのX座標を取得する
            let positionX = self.getMovingLabelPosX(
                scrollViewLayoutWidth: Int(self.targetHeaderScrollView.frame.width),
                separateValue: 3,
                page: page,
                charWidth: buttonTextWidth
            )
            
            //アニメーションで動くラベル（下線）の動かす位置を設定する
            self.movingLabel.frame = CGRect(
                x: positionX,
                y: SlideMenuSetting.movingLabelY,
                width: buttonTextWidth,
                height: SlideMenuSetting.movingLabelH
            )
            
        }, completion: nil)
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
    fileprivate func getMovingLabelPosX(scrollViewLayoutWidth: Int, separateValue: Int, page: Int, charWidth: Int) -> Int {
        
        /**
         * 下記のような計算式で位置を算出する：
         * ★ (動くラベルのX座標位置) = (ボタンを入れたスクロールビューの幅 ÷ ボタン数 ÷ 2) + (ボタンを入れたスクロールビューの幅 ÷ 分割数 × 現在のページ番号) - (ボタンに表示している文字の幅 ÷ 2)
         */
        let positionX: Int = Int(scrollViewLayoutWidth / separateValue / 2) + Int(Int(scrollViewLayoutWidth / 3) * page) - Int(charWidth / 2)
        return positionX
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
