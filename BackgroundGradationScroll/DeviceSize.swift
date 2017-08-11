//
//  DeviceSize.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/08/11.
//  Copyright © 2017年 just1factory. All rights reserved.
//

struct DeviceSize {
    
    //CGRectを取得
    static func bounds() -> CGRect {
        return UIScreen.main.bounds
    }
    
    //画面の横サイズを取得
    static func screenWidthToInt() -> Int {
        return Int(self.bounds().width)
    }
    
    //画面の縦サイズを取得
    static func screenHeightToInt() -> Int {
        return Int(self.bounds().height)
    }
}
