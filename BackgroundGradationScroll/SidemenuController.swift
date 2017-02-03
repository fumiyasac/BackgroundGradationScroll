//
//  SidemenuController.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/24.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class SidemenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //UIパーツの配置
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var bannerButton: UIButton!
    
    //サイドメニューの表示内容
    let sideMenu: [[String]] = MenuMaker.setMenuList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テーブルビューのセットアップ
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        sideMenuTableView.rowHeight = 46.5

        //Xibのセットアップ
        let nibTableView: UINib = UINib(nibName: "SideMenuCell", bundle: nil)
        sideMenuTableView.register(nibTableView, forCellReuseIdentifier: "SideMenuCell")
    }

    /* (UITableViewDelegate) */
    
    //テーブルのセクションのセル数を設定する
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenu.count
    }

    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120.0
    }

    /* (UITableViewDataSource) */
    
    //表示するセルの中身を設定する
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as? SideMenuCell
        
        //TODO: 取得データをセルに表示させる
        let sideMenuData = sideMenu[indexPath.row]
        cell?.iconImageView.image = nil
        cell?.menuNameLabel.text = sideMenuData[1]
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }

    //バナー部分のボタンを押下した際のアクション
    @IBAction func bannerButtonAction(_ sender: UIButton) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
