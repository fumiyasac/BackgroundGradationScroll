//
//  ImageHeaderTransition.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/19.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import Foundation

import UIKit

class ImageHeaderTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    //トランジションの秒数
    let duration      = 0.36
    
    //トランジションの方向(present: true, dismiss: false)
    var presenting    = true
    
    //アニメーション対象なるサムネイル画像の位置やサイズ情報を格納するメンバ変数
    var originalFrame = CGRect.zero

    //アニメーションの時間を定義する
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    /**
     * アニメーションの実装を定義する
     * この場合には画面遷移コンテキスト（UIViewControllerContextTransitioningを採用したオブジェクト）
     * → 遷移元や遷移先のViewControllerやそのほか関連する情報が格納されているもの
     */
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //コンテキストを元にViewのインスタンスを取得する（存在しない場合は処理を終了）
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        //アニメーションの実態となるコンテナビューを作成
        let containerView = transitionContext.containerView
        
        //遷移先のViewController・始めと終わりのViewのサイズ・拡大値と縮小値を決定する
        var targetView: UIView!
        var initialFrame: CGRect!
        var finalFrame: CGRect!
        
        //Case1: 進む場合
        if presenting {
            
            targetView = toView
            initialFrame = originalFrame
            finalFrame = targetView.frame
            
            targetView.alpha = 0
            
        //Case2: 戻る場合
        } else {
            
            targetView = fromView
            initialFrame = targetView.frame
            finalFrame = originalFrame
            
            targetView.alpha = 1
        }
        
        targetView.frame = initialFrame
        targetView.clipsToBounds = true

        //アニメーションの実体となるContainerViewに必要なものを追加する
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: targetView)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {

            //変数durationでの設定した秒数でアルファの切り替えを行う
            targetView.frame = finalFrame
            targetView.alpha = self.presenting ? 1 : 0
            
        }, completion:{ finished in

            transitionContext.completeTransition(true)
        })
    }
}
