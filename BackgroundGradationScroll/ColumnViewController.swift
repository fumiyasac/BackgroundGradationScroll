//
//  ColumnViewController.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/16.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

//FIXME: カテゴリーバー実装用モック（後で消す）
struct CategoryBarMock {
    static func getCategoryBarMock() -> [String] {
        return ["イタリアン", "フレンチ", "中華料理", "ホテルレストラン", "知る人ぞ知る", "創作料理その他"]
    }
}

//カテゴリメニューの動くラベル位置の定数
struct CategoryMenuSetting {
    static let movingLabelY = 40
    static let movingLabelH = 2
}

class ColumnViewController: UIViewController, UIScrollViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UINavigationControllerDelegate {

    //現在位置を保持するメンバ変数
    fileprivate var currentDisplay: Int = 0 {
        didSet {
            self.moveButtonScrollContents(page: currentDisplay)
        }
    }

    //ボタンスクロール時の移動量
    fileprivate var scrollButtonOffsetX: Int!
    
    //スクロールビュー内のボタンを一度だけ生成するフラグ
    fileprivate var layoutOnceFlag: Bool = false
    
    //スクロール内の動くラベル
    fileprivate let movingLabel = UILabel()
    
    //カテゴリ表記用のラベルに関するセッティング
    fileprivate var categoryButtonList: [String] = CategoryBarMock.getCategoryBarMock()
    fileprivate var categoryButtonImpl: [UIButton] = []
    fileprivate var categoryButtonCount: Int = CategoryBarMock.getCategoryBarMock().count
    
    //UIパーツの配置
    @IBOutlet weak var pageScrollContentsContainerView: UIView!
    @IBOutlet weak var backgroundCategoryImage: UIImageView!
    @IBOutlet weak var categoryBarScrollView: UIScrollView!
    
    //ContainerViewにEmbedしたUIPageViewControllerのインスタンスを保持する
    var pageViewController: UIPageViewController?
    
    //ページングして表示させるViewControllerを保持する
    var viewControllerLists = [ColumnListController]()

    //画面表示が開始された際のライフサイクル
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //NavigationControllerのカスタマイズを行う(ナビゲーションを透明にする)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.tintColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Storyboard上に配置したViewController(StoryboardID = ColumnListController)をインスタンス化して配列に追加する
        for index in 0...(CategoryBarMock.getCategoryBarMock().count - 1) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Column", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ColumnListController") as! ColumnListController
            
            //TODO: 渡すパラメータに応じて表示が変わる（Alamofireと受け取る側のControllerのdidSetを併用？）
            
            //TEST: ラベルに番号を入れる（後で削除）
            vc.targetIndex = index.description

            //「タグ番号 = インデックスの値」でスワイプ完了時にどのViewControllerかを判別できるようにする
            vc.view.tag = index
            viewControllerLists.append(vc)
        }
        
        //ContainerViewにEmbedしたUIPageViewControllerを取得する
        pageViewController = childViewControllers[0] as? UIPageViewController
        
        //UIPageViewControllerのデータソースの宣言
        pageViewController!.delegate = self
        pageViewController!.dataSource = self
        
        //最初に表示する画面として配列の先頭のViewControllerを設定する
        pageViewController!.setViewControllers([viewControllerLists[0]], direction: .forward, animated: false, completion: nil)
    }

    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //動的に配置する見た目要素は一度だけ実行する
        if layoutOnceFlag == false {
            
            //コンテンツ用のScrollViewを初期化
            initScrollViewDefinition()
            
            //スクロールビュー内のサイズを決定する
            categoryBarScrollView.contentSize = CGSize(
                width: CGFloat(Int(categoryBarScrollView.frame.width / 3) * categoryButtonCount),
                height: categoryBarScrollView.frame.height
            )
            
            //メインのスクロールビューの中にコンテンツ表示用のコンテナを一列に並べて配置する
            for i in 0...(categoryButtonCount - 1) {
                
                //メニュー用のスクロールビューにボタンを配置
                let buttonElement: UIButton! = UIButton()
                categoryBarScrollView.addSubview(buttonElement)
                
                //ボタンのサイズを決定する
                buttonElement.frame = CGRect(
                    x: CGFloat(Int(categoryBarScrollView.frame.width) / 3 * i),
                    y: 0,
                    width: categoryBarScrollView.frame.width / 3,
                    height: categoryBarScrollView.frame.height
                )
                
                //ボタンに関するセッティングを行う
                buttonElement.backgroundColor = UIColor.clear
                buttonElement.setTitle(categoryButtonList[i], for: UIControlState())
                buttonElement.setTitleColor(UIColor.white, for: UIControlState())
                buttonElement.titleLabel!.font = UIFont(name: "Georgia-Bold", size: 11)!
                buttonElement.tag = i
                buttonElement.addTarget(self, action: #selector(ColumnViewController.scrollButtonTapped(button:)), for: .touchUpInside)
                
                //配置したボタンの一覧を配列に格納する（フォントカラーをいじる等の調整用）
                categoryButtonImpl.append(buttonElement)
            }
            
            //初期状態の選択カテゴリーの色を決める（初期状態は一番最初）
            decideSelectedColor()
            
            //動くラベルを配置する
            categoryBarScrollView.addSubview(movingLabel)
            categoryBarScrollView.bringSubview(toFront: movingLabel)
            movingLabel.frame = CGRect(
                x: 0,
                y: CategoryMenuSetting.movingLabelY,
                width: Int(self.view.frame.width / 3),
                height: CategoryMenuSetting.movingLabelH
            )
            movingLabel.backgroundColor = UIColor.orange
            
            //一度だけ実行するフラグを有効化する
            layoutOnceFlag = true
        }
    }

    /* (UIPageViewControllerDelegate) */

    //ページが動いたタイミング（この場合はスワイプアニメーションに該当）に発動する処理を記載するメソッド
    //（実装例）http://c-geru.com/as_blind_side/2014/09/uipageviewcontroller.html
    //（実装例に関する解説）http://chaoruko-tech.hatenablog.com/entry/2014/05/15/103811
    //（公式ドキュメント）https://developer.apple.com/reference/uikit/uipageviewcontrollerdelegate
    internal func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        //スワイプアニメーションが完了していない時には処理をさせなくする
        if !completed {
            return
        }

        //ここから先はUIPageViewControllerのスワイプアニメーション完了時に発動する
        let pageItemController = pageViewController.viewControllers?.last
        let currentPageIndex = pageItemController?.view.tag

        //現在位置の表示インデクス番号をメンバ変数に格納（※didSetのタイミングでナビゲーションを動かす処理を発動する）
        currentDisplay = currentPageIndex!
    }

    /* (UIPageViewControllerDataSource) */

    //逆方向にページ送りした時に呼ばれるメソッド
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //インデックスを取得する
        let index = viewControllerLists.index(of: viewController as! ColumnListController)

        //インデックスの値に応じてコンテンツを動かす
        if index! <= 0 {
            return nil
        } else {
            return viewControllerLists[index! - 1]
        }
    }
    
    //順方向にページ送りした時に呼ばれるメソッド
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        //インデックスを取得する
        let index = viewControllerLists.index(of: viewController as! ColumnListController)

        //インデックスの値に応じてコンテンツを動かす
        if index! >= categoryButtonCount - 1 {
            return nil
        } else {
            return viewControllerLists[index! + 1]
        }
    }

    /* (Button Actions) */

    //遷移元のViewControllerへ戻すアクション
    @IBAction func backViewControllerAction(_ sender: UIButton) {
        
        //【Swift3】navigationControllerのpopViewControllerで警告がでる
        //参考：http://blog.sgr-ksmt.org/2016/10/06/pop_view_controller_swift3/
        let _ = navigationController?.popViewController(animated: true)
    }

    /* (ButtonTapped Functions) */
    
    //ボタンをタップした際に行われる処理
    func scrollButtonTapped(button: UIButton) {
        
        //押されたボタンのタグを取得
        let page: Int = button.tag
        
        //遷移の方向用の変数を用意する
        var targetDirection: UIPageViewControllerNavigationDirection? = nil
        var targetAnimated: Bool = false
        
        //現在位置と遷移先のインデックスの差分から動く方向を設定する
        if currentDisplay - page == 0 {
            return
        } else if currentDisplay - page > 0 {
            targetDirection = .reverse
        } else if currentDisplay - page < 0 {
            targetDirection = .forward
        }

        //遷移先がお隣さんであればアニメーションを有効にする
        if abs(currentDisplay - page) == 1 {
            targetAnimated = true
        } else {
            targetAnimated = false
        }
        
        //現在位置の表示インデクス番号をメンバ変数に格納（※didSetのタイミングでナビゲーションを動かす処理を発動する）
        currentDisplay = page

        //ページのインデックス番号に該当するViewControllerを設定する
        pageViewController!.setViewControllers([viewControllerLists[page]], direction: targetDirection!, animated: targetAnimated, completion: nil)
    }

    /* (Fileprivate Functions) */

    //ボタンのスクロールビューをスライドさせる
    fileprivate func moveButtonScrollContents(page: Int) {
        
        //メソッドが実行された時はユーザーの操作をできないようにする
        categoryBarScrollView.isUserInteractionEnabled = false
        pageViewController?.view.isUserInteractionEnabled = false

        //Case1: ボタンを内包しているスクロールビューの位置変更をする
        if page > 0 && page < (categoryButtonCount - 1) {
            
            scrollButtonOffsetX = Int(categoryBarScrollView.frame.width) / 3 * (page - 1)
            
        //Case2: 一番最初のpage番号のときの移動量
        } else if page == 0 {
            
            scrollButtonOffsetX = 0
            
        //Case3: 一番最後のpage番号のときの移動量
        } else if page == (categoryButtonCount - 1) && page % 3 == 2 {
            
            scrollButtonOffsetX = Int(categoryBarScrollView.frame.width) * (categoryButtonCount / 3 - 1)
            
        //Case4: 一番最後のpage番号のときの移動量 ※(page % 分割数 + 1 ≠ 分割数)の場合
        } else if page == (categoryButtonCount - 1) && page % 3 != 2 {
            
            scrollButtonOffsetX = Int(categoryBarScrollView.frame.width) / 3 * (page - 2)
        }
        
        //アニメーションでタブの中央位置を移動させる
        UIView.animate(withDuration: 0.26, delay: 0, options: [], animations: {
            
            //動かすオフセット値を反映させた上で表示対象のカテゴリーを中央に表示させる
            self.categoryBarScrollView.contentOffset = CGPoint(
                x: self.scrollButtonOffsetX,
                y: 0
            )

            //ボタンタップ時に動くラベルをスライドさせる
            self.movingLabel.frame = CGRect(
                x: Int(self.view.frame.width) / 3 * page,
                y: CategoryMenuSetting.movingLabelY,
                width: Int(self.view.frame.width) / 3,
                height: CategoryMenuSetting.movingLabelH
            )

            //選択したカテゴリーの色設定を行う
            self.decideSelectedColor()

        }, completion: { finished in

            //アニメーションが完了した時はユーザーの操作ができるようにする
            self.categoryBarScrollView.isUserInteractionEnabled = true
            self.pageViewController?.view.isUserInteractionEnabled = true
        })
    }
    
    //サイドバー用のUIScrollViewの初期化を行う
    fileprivate func initScrollViewDefinition() {
        
        //スクロールビュー内の各プロパティ値を設定する
        categoryBarScrollView.isPagingEnabled = false
        categoryBarScrollView.isScrollEnabled = true
        categoryBarScrollView.isDirectionalLockEnabled = false
        categoryBarScrollView.showsHorizontalScrollIndicator = false
        categoryBarScrollView.showsVerticalScrollIndicator = false
        categoryBarScrollView.bounces = false
        categoryBarScrollView.scrollsToTop = false
    }
    
    //選択したボタンを判定して現在選択中の色をつける
    fileprivate func decideSelectedColor() {

        //viewDidLayoutSubviewsで格納したボタンの一覧に対して色の決定をする
        for (index, targetButton) in categoryButtonImpl.enumerated() {
            if index == currentDisplay {
                targetButton.setTitleColor(UIColor.orange, for: UIControlState())
            } else {
                targetButton.setTitleColor(UIColor.white, for: UIControlState())
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
