//
//  StoryboardInstantiatable.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/07/23.
//  Copyright © 2017年 just1factory. All rights reserved.
//

public protocol StoryboardInstantiatable {

    static var storyboardName: String { get }
    static var viewControllerIdentifier: String? { get }
    static var bundle: Bundle? { get }
}

extension StoryboardInstantiatable where Self: UIViewController {
    static var storyboardName: String {
        return String(describing: self)
    }
    
    static var viewControllerIdentifier: String? {
        return nil
    }
    
    static var bundle: Bundle? {
        return nil
    }
    
    static func instantiate() -> Self {
        let loadViewController = { () -> UIViewController? in
            let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
            if let viewControllerIdentifier = viewControllerIdentifier {
                return storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
            } else {
                return storyboard.instantiateInitialViewController()
            }
        }
        
        guard let viewController = loadViewController() as? Self else {
            fatalError([
                "Failed to load viewcontroller from storyboard.",
                "storyboard: \(storyboardName), viewControllerID: \(String(describing: viewControllerIdentifier)), bundle: \(String(describing: bundle))"
                ].joined(separator: " ")
            )
        }
        return viewController
    }
}
