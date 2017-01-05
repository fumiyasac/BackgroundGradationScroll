//
//  RestaurantDetailController.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/05.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class RestaurantDetailController: UITableViewController {

    //バウンドするヘッダーを作成するためのメンバ変数
    fileprivate var headerView: UIView!
    fileprivate let kTableHeaderHeight: CGFloat = 280.0
    
    //ヘッダー内に設定したイメージビュー
    @IBOutlet weak var targetHeaderImageView: UIImageView!

    //ヘッダー下部分にあるスクロールビュー
    @IBOutlet weak var targetHeaderScrollView: UIScrollView!

    //レイアウトを一度だけ行うフラグ変数
    fileprivate var layoutOnce: Bool = false
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }

    /* (UIScrollViewDelegate) */

    //スクロールが検知された時に実行される処理
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //ヘッダー下部分にあるスクロールビューの場合とそうでない場合で処理を分ける
        if scrollView != targetHeaderScrollView {

            //ヘッダーをスクロールに応じて動かす
            updateTableViewHeader()
            
        } else {
            
        }
    }

    //ドラッグが開始された際に行われる処理
    //参考: http://qiita.com/KatagiriSo/items/323c23e49dc49165b43c
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        //ヘッダー下部分にあるスクロールビューの場合
        if scrollView != targetHeaderScrollView {
            
            //ナビゲーションのスクロールビューを非表示にする
            UIView.animate(withDuration: 0.16, animations: {
                self.targetHeaderScrollView.isUserInteractionEnabled = false
                self.targetHeaderScrollView.alpha = 0.0
            }, completion:{ finished in
            })
        }
    }

    //慣性スクロールの減速が止まった際（急停止時）に行われる処理
    //参考: http://qiita.com/KatagiriSo/items/323c23e49dc49165b43c
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        //ヘッダー下部分にあるスクロールビューの場合
        if scrollView != targetHeaderScrollView {

            //ナビゲーションのスクロールビューを表示する
            UIView.animate(withDuration: 0.16, animations: {
                self.targetHeaderScrollView.isUserInteractionEnabled = true
                self.targetHeaderScrollView.alpha = 1.0
            }, completion:{ finished in
            })
        }
    }

    /* (Functions) */
    
    //ヘッダーのイメージビューのGestureRecognizer発動時に呼ばれる
    func changeTargetHeaderImageView(sender: UITapGestureRecognizer) {
        print("Target Header ImageTapped.")
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

}
