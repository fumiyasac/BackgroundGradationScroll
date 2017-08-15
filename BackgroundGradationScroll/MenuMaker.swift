//
//  MenuMaker.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/02/03.
//  Copyright © 2017年 just1factory. All rights reserved.
//

struct MenuMaker {

    /**
     * Menuコンテンツ部分は決め打ちになるので下記のように定義
     * 0番目 → メニュー画像名
     * 1番目 → メニュー文言
     * ...(追加があればここに追記)
     */
    static func setMenuList() -> [[String]] {
        return [
            ["image1", "メニュー名1"],
            ["image2", "メニュー名2"],
            ["image3", "メニュー名3"],
            ["image4", "メニュー名4"],
            ["image5", "メニュー名5"],
            ["image6", "メニュー名6"]
        ]
    }
}
