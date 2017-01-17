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

class ColumnViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPageViewControllerDataSource {

    //上タブのサイズを格納するメンバ変数
    fileprivate var pageTabItemsWidth: CGFloat = 0.0
    
    //
    fileprivate var initialStateItemIndex: Int = 6
    
    //UIパーツの配置
    @IBOutlet weak var categoryBarCollectionView: UICollectionView!
    @IBOutlet weak var pageScrollContentsContainerView: UIView!
    
    //ContainerViewにEmbedしたUIPageViewControllerのインスタンスを保持する
    var pageViewController: UIPageViewController?
    
    //ページングして表示させるViewControllerを保持する
    var viewControllerLists = [ColumnListController]()
    
    //
    override func viewDidAppear(_ animated: Bool) {
        categoryBarCollectionView.scrollToItem(at: IndexPath(item: 6, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CollectionViewのデリゲート・データソースの宣言
        categoryBarCollectionView.delegate = self
        categoryBarCollectionView.dataSource = self
        
        //CollectionViewのXibのクラスを読み込む宣言を行う
        let nibCategoryBarCell: UINib = UINib(nibName: "CategoryBarCell", bundle: nil)
        categoryBarCollectionView.register(nibCategoryBarCell, forCellWithReuseIdentifier: "CategoryBarCell")
        
        //Storyboard上に配置したViewController(StoryboardID = ColumnListController)をインスタンス化して配列に追加する
        for index in 0...9 {
            let storyboard: UIStoryboard = UIStoryboard(name: "Column", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ColumnListController") as! ColumnListController
            vc.labelStr = index.description
            viewControllerLists.append(vc)
        }

        //ContainerViewにEmbedしたUIPageViewControllerを取得する
        pageViewController = childViewControllers[0] as? UIPageViewController
        
        //UIPageViewControllerのデータソースの宣言
        pageViewController!.dataSource = self
        
        //最初に表示する画面として配列の先頭のViewControllerを設定する
        pageViewController!.setViewControllers([viewControllerLists[0]], direction: .forward, animated: false, completion: nil)
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //(ロジックの参考)http://tech.vasily.jp/entry/tab_page_viewcontroller
        //表示したい要素群のwidthを計算
        if pageTabItemsWidth == 0.0 {
            pageTabItemsWidth = floor(scrollView.contentSize.width / 3.0)
        }

        //スクロールした位置がしきい値を超えたら中央に戻す
        if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x > pageTabItemsWidth * 2.0) {
            scrollView.contentOffset.x = pageTabItemsWidth
        }
    }

    /* (UICollectionViewDelegate) */
    
    //このコレクションビューのセクション数を決める
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /* (UICollectionViewDataSource) */
    
    //セクションのアイテム数を設定する
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        //要素数の3倍を持っておく
        //(ロジックの参考)http://tech.vasily.jp/entry/tab_page_viewcontroller
        return CategoryBarMock.getCategoryBarMock().count * 3
    }
    
    //セルに表示する値を設定する
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        //セルの定義を行う
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryBarCell", for: indexPath) as! CategoryBarCell

        //カテゴリーの表示
        let index = indexPath.row % CategoryBarMock.getCategoryBarMock().count
        cell.categoryIndex = index
        
        cell.categoryBarName.text = CategoryBarMock.getCategoryBarMock()[index]
        return cell
    }
    
    /* (UICollectionViewDelegateFlowLayout) */
    
    //セル名「CategoryBarCell」のサイズを返す
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //セルのサイズを返す（配置したUICollectionViewのセルの高さを合わせておく必要がある）
        return CategoryBarCell.cellOfSize()
    }

    //
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryBarCell
        print(cell.categoryIndex)
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //セルの垂直方向の余白(margin)を設定する
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    //セルの水平方向の余白(margin)を設定する
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    //セル内のアイテム間の余白(margin)調整を行う
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    /* (UIPageViewControllerDataSource) */

    //逆方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = viewControllerLists.index(of: viewController as! ColumnListController) else {
            return nil
        }

        //無限ページングの考慮をしたコンテンツ切り替え
        let targetIndex = (index == 0) ? viewControllerLists.count - 1 : (index - 1) % viewControllerLists.count

        return viewControllerLists[targetIndex]
    }
    
    //順方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = viewControllerLists.index(of: viewController as! ColumnListController) else {
            return nil
        }

        //無限ページングの考慮をしたコンテンツ切り替え
        let targetIndex = (index + 1) % viewControllerLists.count

        return viewControllerLists[targetIndex]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
