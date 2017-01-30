//
//  RestaurantDetailTransition.swift
//  BackgroundGradationScroll
//
//  Created by 酒井文也 on 2017/01/19.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import Foundation

import UIKit

class RestaurantDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    //トランジションの秒数
    let duration: TimeInterval = 0.26
    
    //ポップアップ表示時の角丸の値（※画面遷移時のCoreAnimation用）
    let radius: CGFloat = 16.0
    
    //縮小値（※画面遷移時のCoreAnimation用）
    let scale: CGFloat = 0.92
    
    //トランジションの方向(present: true, dismiss: false)
    var presenting = true
    
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
        
        //アニメーションの実体となるコンテナビューを作成
        let containerView = transitionContext.containerView
        
        //始めと終わりのViewと
        var previousView: UIView!
        var targetView: UIView!
        var initialFrame: CGRect!
        var finalFrame: CGRect!
        
        //Case1: 進む場合
        if presenting {
            
            previousView = fromView
            targetView = toView
            initialFrame = originalFrame
            finalFrame = targetView.frame
            
            targetView.alpha = 0.00
            
        //Case2: 戻る場合
        } else {
            
            previousView = toView
            targetView = fromView
            initialFrame = targetView.frame
            finalFrame = originalFrame
            
            targetView.alpha = 1.00
        }
        
        targetView.frame = initialFrame
        targetView.clipsToBounds = true

        //アニメーションの実体となるContainerViewに必要なものを追加する
        containerView.addSubview(previousView)
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: targetView)
        
        UIView.animate(withDuration: duration, delay: 0.00, options: [], animations: {

            //CoreAnimationの種類と適用される秒数を決定する
            let round = CABasicAnimation(keyPath: "cornerRadius")
            round.duration = self.duration
            
            //targetView（カスタムトランジションの元となるView）の値を格納する変数
            var targetRadius: CGFloat
            var targetAlpha: CGFloat
            
            //Case1: 進む場合
            if self.presenting {
                
                previousView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
                previousView.alpha = 0.00
                
                round.fromValue = 0.00
                round.toValue = self.radius
                
                targetRadius = self.radius
                targetAlpha = 1.00
                
            //Case2: 戻る場合
            } else {

                toView.transform = CGAffineTransform.identity
                toView.alpha = 1.00

                round.fromValue = self.radius
                round.toValue = 0.00
                
                targetRadius = 0.00
                targetAlpha = 0.00
            }
            
            //アニメーションで変化させる値を決定する（大きさとアルファに関する値）
            targetView.frame = finalFrame
            targetView.alpha = targetAlpha

            //CoreAnimationで変化させる値を決定する（角丸の値）
            targetView.layer.add(round, forKey: nil)
            targetView.layer.cornerRadius = targetRadius
            
        }, completion:{ finished in

            //遷移元のViewControllerを表示しているViewは消去しておく
            previousView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
