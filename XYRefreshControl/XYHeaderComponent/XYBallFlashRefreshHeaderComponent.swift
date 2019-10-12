//
//  XYBallFlashRefreshHeaderComponent.swift
//  eltx_driver
//
//  Created by yang on 2019/9/26.
//  Copyright © 2019 yang. All rights reserved.
//

import UIKit
import AVFoundation

public class XYBallFlashRefreshHeaderComponent: UIView, XYRefershHeaderComponentType {
    public var view: UIView  { return self }
    
    public var refreshingHeight: CGFloat = 50.0
    
    public var triggerHeight: CGFloat = 100.0
    
    public let ballNormalSize = CGSize.init(width: 8.0, height: 8.0)
    
    public let ballBigSize = CGSize.init(width: 10.0, height: 10.0)
    
    public let leftBall = CAShapeLayer.init()
    
    public let middleBall = CAShapeLayer.init()
    
    public let rightBall = CAShapeLayer.init()
    
    public let color = UIColor.lightGray
    
    public let width = UIScreen.main.bounds.size.width
    
    public let innerSpace: CGFloat = 18.0
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0.0, y: 0.0, width: width, height: self.refreshingHeight))
        self.setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupUI() {
        leftBall.backgroundColor = color.cgColor
        rightBall.backgroundColor = color.cgColor
        middleBall.backgroundColor = color.cgColor
        leftBall.masksToBounds = true
        rightBall.masksToBounds = true
        middleBall.masksToBounds = true
        layer.addSublayer(leftBall)
        layer.addSublayer(rightBall)
        layer.addSublayer(middleBall)
    }
    
    public func stateNormal(state: XYRefreshState) {

    }
    
    public func stateWillRefresh(state: XYRefreshState) {
        AudioServicesPlaySystemSound(1519)
    }
    
    public func stateRefreshing(state: XYRefreshState) {
        
    }
    
    public func component(state: XYRefreshState, progress: CGFloat) {
        print("\(state),\(progress)")
        let newMW = ballBigSize.width - (ballBigSize.width - ballNormalSize.width) * progress
        let newMH = newMW
        middleBall.frame = CGRect.init(origin: CGPoint.init(x: width / 2.0 - newMW / 2.0, y: self.refreshingHeight / 2.0 - newMH / 2.0), size: CGSize.init(width: newMW, height: newMH))
        middleBall.cornerRadius = newMW / 2.0
        leftBall.frame = CGRect.init(origin: CGPoint.init(x: width / 2.0 - ballNormalSize.width / 2.0 + innerSpace * progress, y: self.refreshingHeight / 2.0 - ballNormalSize.height / 2.0), size: ballNormalSize)
        leftBall.cornerRadius = ballNormalSize.width / 2.0
        rightBall.frame = CGRect.init(origin: CGPoint.init(x: width / 2.0 - ballNormalSize.width / 2.0 - innerSpace * progress, y: self.refreshingHeight / 2.0 - ballNormalSize.height / 2.0), size: ballNormalSize)
        rightBall.cornerRadius = ballNormalSize.width / 2.0
        middleBall.removeAllAnimations()
        leftBall.removeAllAnimations()
        rightBall.removeAllAnimations()
        if state == .refreshing {
            let duration: CFTimeInterval = 0.7
            let beginTime = CACurrentMediaTime()
            let beginTimes = [0.35, 0, 0.35]
            let scaleAnimation = CAKeyframeAnimation.init(keyPath: "transform.scale")
            scaleAnimation.keyTimes = [0, 0.5, 1]
            scaleAnimation.values = [1.25, 0.75, 1.25]
            let alphaAnimation = CAKeyframeAnimation.init(keyPath: "opacity")
            alphaAnimation.keyTimes = [0, 0.5, 1]
            alphaAnimation.values = [1, 0.2, 1]
            let animationGroup = CAAnimationGroup.init()
            animationGroup.animations = [scaleAnimation, alphaAnimation]
//            animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.init(rawValue: "linear"))
            animationGroup.duration = duration
            animationGroup.repeatCount = HUGE
            animationGroup.beginTime = beginTime + beginTimes[1]
            middleBall.add(animationGroup, forKey: "animation")
            animationGroup.beginTime = beginTime + beginTimes[0]
            leftBall.add(animationGroup, forKey: "animation")
            animationGroup.beginTime = beginTime + beginTimes[2]
            rightBall.add(animationGroup, forKey: "animation")
        }
    }
    
}
