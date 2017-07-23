//
//  NSObjectProtocol.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/07/23.
//  Copyright © 2017年 just1factory. All rights reserved.
//

//
extension NSObjectProtocol {
    
    //
    static var className: String {
        return String(describing: self)
    }
}

//
extension UITableViewCell {
    
    //
    static var identifier: String {
        return className
    }
}

//
extension UITableView {

    //
    func registerCustomCell<T: UITableViewCell>(_ cellType: T.Type) {
        register(UINib(nibName: T.identifier, bundle: nil), forCellReuseIdentifier: T.identifier)
    }

    //
    func dequeueReusableCustomCell<T: UITableViewCell>(with cellType: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier) as! T
    }
}
