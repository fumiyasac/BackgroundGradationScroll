//
//  NSObjectProtocol.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/07/23.
//  Copyright © 2017年 just1factory. All rights reserved.
//

//NSObjectProtocolの拡張
extension NSObjectProtocol {
    
    //クラス名を返す変数"className"を返す
    static var className: String {
        return String(describing: self)
    }
}

//UITableViewCellの拡張
extension UITableViewCell {

    //独自に定義したセルのクラス名を返す
    static var identifier: String {
        return className
    }
}

//UITableViewの拡張
extension UITableView {

    //作成した独自のカスタムセルを初期化するメソッド
    func registerCustomCell<T: UITableViewCell>(_ cellType: T.Type) {
        register(UINib(nibName: T.identifier, bundle: nil), forCellReuseIdentifier: T.identifier)
    }

    //作成した独自のカスタムセルをインスタンス化するメソッド
    func dequeueReusableCustomCell<T: UITableViewCell>(with cellType: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier) as! T
    }
}
