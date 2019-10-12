//
//  XYRefersh.swift
//  eltx_driver
//
//  Created by yang on 2019/9/19.
//  Copyright © 2019 yang. All rights reserved.
//

import UIKit

//MARK:-------Basic Refresh

 public class XYRefreshControl: UIView {
    
    public static var context = "XYRefreshKVOContext"
    
    public var componentView: UIView?
    
    public var state: XYRefreshState = .normal
    
    public var triggerHeight: CGFloat = 0.0
    
    public var scrollView: UIScrollView?
    
    public var action: (() -> ())?
    
    public init(componentView: UIView, action: @escaping (() -> ())) {
        let height = componentView.bounds.size.height
        super.init(frame: CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: height))
        self.componentView = componentView
        //默认触发高度为component高度
        self.triggerHeight = height
        self.action = action
//        self.componentView!.frame = CGRect.init(x: 0.0, y: 0.0, width: xyScreenUtil.screenWidth, height: height)
        self.addSubview(componentView)
        self.layer.masksToBounds = true
//        let top = NSLayoutConstraint.init(item: componentView, attribute: .topMargin, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1.0, constant: 0.0)
//        let left = NSLayoutConstraint.init(item: componentView, attribute: .leftMargin, relatedBy: .equal, toItem: self, attribute: .leftMargin, multiplier: 1.0, constant: 0.0)
//        let right = NSLayoutConstraint.init(item: componentView, attribute: .rightMargin, relatedBy: .equal, toItem: self, attribute: .rightMargin, multiplier: 1.0, constant: 0.0)
//        let bottom = NSLayoutConstraint.init(item: componentView, attribute: .bottomMargin, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0)
//        let heightNC = NSLayoutConstraint.init(item: componentView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)
//        let widthNC = NSLayoutConstraint.init(item: componentView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
//        self.addConstraints([top, left, right, bottom])
//        componentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin,.flexibleTopMargin, .flexibleBottomMargin]
        let centerX = NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerY = NSLayoutConstraint.init(item: self, attribute: .centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.addConstraints([centerX, centerY])
        componentView.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin,.flexibleBottomMargin, .flexibleLeftMargin]
//        self.backgroundColor = UIColor.green
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let scrollView = newSuperview as? UIScrollView else {return}
        self.scrollView = scrollView
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: &XYRefreshControl.context)
        scrollView.addObserver(self, forKeyPath: "contentInset", options: NSKeyValueObservingOptions.new, context: &XYRefreshControl.context)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "contentOffset")
        self.removeObserver(self, forKeyPath: "contentInset")
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &XYRefreshControl.context {
            if keyPath == "contentOffset" {
                self.scrollViewContentOffsetChanged(forKeyPath: keyPath, of: object, change: change, context: context)
            }
            if keyPath == "contentInset" {
                self.scrollViewContentInsetChanged(forKeyPath: keyPath, of: object, change: change, context: context)
            }
            
        }
    }
    
    public func scrollViewContentOffsetChanged(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    
    public func scrollViewContentInsetChanged(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    
}

public protocol XYRefreshStateType {}

public enum XYRefreshState: XYRefreshStateType {
    /// 正常状态
    case normal
    /// 即将刷新
    case willRefresh
    /// 刷新
    case refreshing
    /// 没有更多数据(用于footer)
    case noMoreData
}

extension XYRefreshState {
    var description: String {
        get {
            return ""
        }
    }
}


public class XYRefreshHeader: XYRefreshControl {
    
    public enum Model {
        case follow //跟随 (类似于mjrefresh绝大部分跟随效果)
        case onlyRefreshingSuck //只在刷新状态先吸顶(下拉的时候跟随，刷新的时候吸顶)
        case alawaysSuck //不管什么情况下都吸顶(类似于UIRefreshControl)
    }
    
    public var component: XYRefershHeaderComponentType?
    
    public var model: Model = .follow
    
    public override var state: XYRefreshState {
        didSet {
            switch self.state {
            case .normal:
                if self.state == oldValue { return }
                if oldValue == .refreshing {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.25, animations: {
                            self.scrollView!.contentInset.top -= self.component!.refreshingHeight
                        }, completion: { (finished) in
//                            self.scrollView!.setContentOffset(CGPoint.init(x: 0.0, y: -self.scrollView!.contentInset.top), animated: true)
                        })
                    }
                }
                
                if component != nil {
                    component!.stateNormal(state: self.state)
                }
            case .willRefresh:
                if self.state == oldValue { return }
                
                if component != nil {
                    component!.stateWillRefresh(state: self.state)
                }
            case .refreshing:
                if self.state == oldValue { return }
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.25, animations: {
////                        self.scrollView!.setContentOffset(CGPoint.init(x: 0.0, y: -(self.scrollView!.contentInset.top + self.component!.height)), animated: true)
                        self.scrollView!.contentInset.top += self.component!.refreshingHeight
                    }, completion: { (finished) in
                        
                    })
                }
                
                if component != nil {
                    component!.stateRefreshing(state: self.state)
                }
                if self.action != nil {
                    self.action!()
                }
            default: break
            }
        }
    }
    
    public init(component: XYRefershHeaderComponentType = XYBasicRefershHeaderComponent.init(), model: Model = Model.follow, action: @escaping (() -> ())) {
        super.init(componentView: component.view, action: action)
        self.component = component
        self.triggerHeight = component.triggerHeight
        self.model = model
        component.stateNormal(state: .normal)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let scrollView = newSuperview as? UIScrollView else { return }
        // normal 在contentSize头部
        var newFrame = self.frame
        newFrame.origin.y = -self.component!.refreshingHeight
        self.frame = newFrame
    }
    
    override public func scrollViewContentOffsetChanged(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = self.scrollView else { return }
        let contentOffset = scrollView.contentOffset
        let inset = scrollView.contentInset
        var safeAreaInsetTop: CGFloat = 0.0
        if #available(iOS 11, *) {
            if scrollView.contentInsetAdjustmentBehavior != .never {
                safeAreaInsetTop = scrollView.safeAreaInsets.top
            }
        }
        let maxY = -(scrollView.contentInset.top + self.triggerHeight + safeAreaInsetTop)
        let offsetY = contentOffset.y
        
        //在ScrollView上的component的位置更新
//        print("state:\(self.state),offsetY:\(offsetY),insetTop:\(inset.top)")
        switch self.model {
        case .follow:
            break
        case .onlyRefreshingSuck:
            //仿UIRefreshControl---onlyRefreshingSuck
            if self.state != .refreshing {
                //在普通状态下
                let suck = offsetY + inset.top + self.component!.refreshingHeight + safeAreaInsetTop
                print("普通状态下的吸顶条件：\(suck)")
                if suck <= 0 {
                    //吸顶模式
                    var newFrame = self.frame
                    newFrame.origin.y = offsetY + (inset.top + safeAreaInsetTop)
                    self.frame = newFrame
                }else {
                    //跟随模式
                    var newFrame = self.frame
                    newFrame.origin.y = -self.component!.refreshingHeight
                    self.frame = newFrame
                }
            }else {
                //在刷新状态下
                //吸顶模式
                var newFrame = self.frame
                newFrame.origin.y = offsetY + (inset.top + safeAreaInsetTop) - self.component!.refreshingHeight
                self.frame = newFrame
                if offsetY + inset.top >= 0 {
                    //跟随模式
                    var newFrame = self.frame
                    newFrame.origin.y = -self.component!.refreshingHeight
                    self.frame = newFrame
                }
            }
            break
        case .alawaysSuck:
            //仿UIRefreshControl---AlwaysSuck
            if self.state != .refreshing {
                //在正常状态下
                var newFrame = self.frame
                newFrame.origin.y = offsetY + (inset.top + safeAreaInsetTop)
                newFrame.size.height = -offsetY - (inset.top + safeAreaInsetTop)
                self.frame = newFrame
            }else {
                //在刷新状态下
                var newFrame = self.frame
                newFrame.origin.y = offsetY + (inset.top + safeAreaInsetTop) - self.component!.refreshingHeight
//                newFrame.size.height = -(offsetY) - inset.top + self.component!.refreshingHeight
                newFrame.size.height = self.component!.refreshingHeight
                self.frame = newFrame
            }
            break
        }
    
        //状态改变
        if (self.state == .refreshing) {return}
        if scrollView.isDragging {
            if (offsetY > maxY){
                self.state = .normal
            }else if (offsetY <= maxY) {
                self.state = .willRefresh
            }
        }else {
            if self.state == .willRefresh {
                self.state = .refreshing
            }
        }
        //开始为0
        //刷新为1
        //其余不做处理
        let progress = (-offsetY - (inset.top + safeAreaInsetTop)) / self.component!.triggerHeight
        self.component!.component(state: self.state, progress: min(1.00, progress))
        
    }
    
//    override func scrollViewContentInsetChanged(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        guard let scrollView = self.scrollView else { return }
//        let contentOffset = scrollView.contentOffset
//        let inset = scrollView.contentInset
//        let maxY = -(scrollView.contentInset.top + self.triggerHeight)
//        let offsetY = contentOffset.y
//
////        在ScrollView上的component的位置更新
//        print("ContentInset offsetY:\(offsetY),insetTop:\(inset.top)")
////        let suck = offsetY + inset.top + self.component!.height
////        print("ContentInset 吸顶条件：\(suck)")
////        if suck <= 0 {
////            //吸顶模式
////            var newFrame = self.frame
////            newFrame.origin.y = offsetY + inset.top
////            self.frame = newFrame
////        }else {
////            //跟随模式
////            var newFrame = self.frame
////            newFrame.origin.y = -self.component!.height
////            self.frame = newFrame
////        }
//        if self.state != .refreshing {
//            //在正常状态下
//            var newFrame = self.frame
//            newFrame.origin.y = offsetY + inset.top
//            //            newFrame.size.height = -offsetY - inset.top
//            self.frame = newFrame
//        }else {
//            //在刷新状态下
//            var newFrame = self.frame
//            newFrame.origin.y = offsetY + inset.top - self.component!.refreshingHeight
//            //            newFrame.size.height = -(offsetY) - inset.top + self.component!.refreshingHeight
//            self.frame = newFrame
//        }
//    }

    public func initState() {
        self.state = .normal
    }
    
    public func startRefreshing() {
        self.state = .refreshing
    }
    
    public func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            self.state = .normal
        }
    }
    
    public func isRefreshing() -> Bool {
        return self.state == .refreshing
    }
}

public class XYRefreshFooter: XYRefreshControl {
    var component: XYRefershFooterComponentType?
    
    override public var state: XYRefreshState {
        didSet {
            if self.state == oldValue { return }
            switch self.state {
            case .normal:
                if oldValue == .refreshing {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.25) {
                            var inset = self.scrollView?.contentInset
                            inset!.bottom -= self.component!.refreshingHeight
                            self.scrollView?.contentInset = inset!
                        }
                    }
                }
                if component != nil {
                    component!.stateNormal(state: self.state)
                }
            case .willRefresh:
                if component != nil {
                    component!.stateWillRefresh(state: self.state)
                }
            case .refreshing:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.25) {
                        self.scrollView?.contentInset.bottom += self.component!.refreshingHeight
                    }
                }
                if component != nil {
                    component!.stateRefreshing(state: self.state)
                }
                if self.action != nil {
                    self.action!()
                }
            case .noMoreData:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.25) {
                        var inset = self.scrollView?.contentInset
                        inset!.bottom += self.component!.refreshingHeight
                        self.scrollView?.contentInset = inset!
                    }
                }
                if component != nil {
                    component!.stateNoMoreData(state: self.state)
                }
                break
            default: break
            }
        }
    }
    
    public init(component: XYRefershFooterComponentType = XYBasicRefershFooterComponent.init(), action: @escaping (() -> ())) {
        super.init(componentView: component.view, action: action)
        self.triggerHeight = component.triggerHeight
        self.component = component
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let scrollView = newSuperview as? UIScrollView else { return }
        var newFrame = self.frame
        newFrame.origin.y = scrollView.contentSize.height
        self.frame = newFrame
    }
    
    public func commitInit() {
        guard let componentView = self.component as? UIView else {return}
        componentView.frame = self.bounds
        self.addSubview(componentView)
    }
    
    
    override public func scrollViewContentOffsetChanged(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            guard let scrollView = self.scrollView else { return }
            let contentOffset = scrollView.contentOffset
            let inset = scrollView.contentInset
            let maxY = -(scrollView.contentInset.top + self.triggerHeight)
            let offsetY = contentOffset.y
            var safeAreaInsetTop: CGFloat = 0.0
            if #available(iOS 11, *) {
                if scrollView.contentInsetAdjustmentBehavior != .never {
                    safeAreaInsetTop = scrollView.safeAreaInsets.top
                }
            }
            var newFrame = self.frame
            newFrame.origin.y = scrollView.contentSize.height
            self.frame = newFrame
            
            //正在刷新 || 没有更多数据 || 下拉操作 ||
            if (self.state == .refreshing) || (self.state == .noMoreData) {return}
            if (offsetY + scrollView.contentInset.top + safeAreaInsetTop <= 0) { self.state = .normal; return }
            if scrollView.isDragging {
                //内容超过一个屏幕
                if scrollView.contentInset.top + safeAreaInsetTop + scrollView.contentSize.height + scrollView.contentInset.bottom >= scrollView.bounds.size.height {
                    let boundaryOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom + self.triggerHeight - scrollView.bounds.size.height
                    if offsetY >= boundaryOffsetY && self.state == .normal {
                        //开始上拉了 松手刷新
//                        self.state = .willRefresh
                        self.state = .refreshing
                    }else {
                        self.state = .normal
                    }
                }else {
                    //内容在一个屏幕内
                    print("上拉-------\(offsetY + scrollView.contentInset.top + safeAreaInsetTop)")
                    if (offsetY + scrollView.contentInset.top + safeAreaInsetTop > self.triggerHeight / 2.0) {
                        print("内容在一个屏幕内")
                        self.state = .willRefresh
                    }else {
                        self.state = .normal
                    }
                }
            }else {
                if self.state == .willRefresh {
                    self.state = .refreshing
                }
            }
        }
    }
    
    public func initState() {
        self.state = .normal
    }
    
    public func startRefreshing() {
        self.state = .refreshing
    }
    
    public func endRefreshing() {
        self.state = .normal
    }
    
    public func resetNoMoreData() {
        self.state = .normal
    }
    
    public func endRefreshingWithNoMoreData() {
        self.state = .noMoreData
    }
    
    public func isRefreshing() -> Bool {
        return self.state == .refreshing
    }
}
