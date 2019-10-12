//
//  XYRefreshComponent.swift
//  eltx_driver
//
//  Created by yang on 2019/9/21.
//  Copyright © 2019 yang. All rights reserved.
//

import UIKit
import AVFoundation

//MARK:-------Refresh Component
public protocol XYRefreshComponentType {
    var view: UIView { get }
    ///刷新时控件的高度
    var refreshingHeight: CGFloat { get }
    ///触发刷新时的触发高度
    var triggerHeight: CGFloat { get }
    ///
    func component(state: XYRefreshState, progress: CGFloat)
}

//MARK:-------Header Refresh Component
public protocol XYRefershHeaderComponentType: XYRefreshComponentType {
    func stateNormal(state: XYRefreshState)
    func stateWillRefresh(state: XYRefreshState)
    func stateRefreshing(state: XYRefreshState)
}

//MARK:-------Footer Refresh Component
public protocol XYRefershFooterComponentType: XYRefreshComponentType {
    func stateNormal(state: XYRefreshState)
    func stateWillRefresh(state: XYRefreshState)
    func stateRefreshing(state: XYRefreshState)
    func stateNoMoreData(state: XYRefreshState)
}

//MARK:-------implementation example -- basic header
public class XYBasicRefershHeaderComponent:UIView, XYRefershHeaderComponentType {
    
    public var triggerHeight: CGFloat = 100.0
    
    public var view: UIView { return self}
    
    public var refreshingHeight: CGFloat = 50.0
    
    public lazy var juhua: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.tintColor = UIColor.gray
        view.startAnimating()
        return view
    }()
    
    public lazy var title: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: refreshingHeight))
//        self.backgroundColor = UIColor.clear
//        self.backgroundColor = UIColor.red
        self.addSubview(juhua)
        self.addSubview(title)
        juhua.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        let titleCenterX = NSLayoutConstraint.init(item: title, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0)
        let titleCenterY = NSLayoutConstraint.init(item: title, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0.0)
        let juhuaCenterY = NSLayoutConstraint.init(item: juhua, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0.0)
        let juhuaCenterX = NSLayoutConstraint.init(item: juhua, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: title, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0)
        self.addConstraints([titleCenterX, titleCenterY, juhuaCenterX, juhuaCenterY])
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func stateNormal(state: XYRefreshState) {
        print("header 下拉刷新")
        self.title.text = "下拉刷新"
        self.juhua.isHidden = true
//        self.juhua.isHidden = false
    }
    
    public func stateWillRefresh(state: XYRefreshState) {
        print("header 松开刷新")
        self.title.text = "松开刷新"
        self.juhua.isHidden = true
//        self.juhua.isHidden = false
        AudioServicesPlaySystemSound(1519)
    }
    
    public func stateRefreshing(state: XYRefreshState) {
        print("header 正在刷新数据")
        self.title.text = ""
        self.juhua.isHidden = false
    }
    
    public func component(state: XYRefreshState, progress: CGFloat) {
        print("state: \(state), progress: \(progress)")
    }
    
}

//MARK:-------implementation example -- basic footer
public class XYBasicRefershFooterComponent: UIView, XYRefershFooterComponentType {
    
    public var triggerHeight: CGFloat = 0.0
    
    public var view: UIView { return self}
    
    public func stateNormal(state: XYRefreshState) {
        print("footer 上拉刷新")
        self.juhua.isHidden = true
        self.noMoreDataView.isHidden = true
    }
    
    public func stateWillRefresh(state: XYRefreshState) {
        print("footer 松开刷新")
        self.juhua.isHidden = false
        self.noMoreDataView.isHidden = true
    }
    
    public func stateRefreshing(state: XYRefreshState) {
        print("footer 正在刷新数据")
        self.juhua.isHidden = false
        self.noMoreDataView.isHidden = true
    }
    
    public func stateNoMoreData(state: XYRefreshState) {
        print("footer 没有更多数据")
        self.juhua.isHidden = true
        self.noMoreDataView.isHidden = false
    }
    
    public func component(state: XYRefreshState, progress: CGFloat) {
        print("state: \(state), progress: \(progress)")
    }
    
    public lazy var juhua: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.tintColor = UIColor.gray
        view.startAnimating()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let juhuaCenterX = NSLayoutConstraint.init(item: view, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0)
        let juhuaCenterY = NSLayoutConstraint.init(item: view, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0.0)
        self.addConstraints([juhuaCenterX, juhuaCenterY])
        return view
    }()
    
    public lazy var noMoreDataView: UIView = {
        let view = UIView.init()
        let leftLine = UIView.init()
        leftLine.backgroundColor = UIColor.lightGray
        let rightLine = UIView.init()
        rightLine.backgroundColor = UIColor.lightGray
        let titleLB = UILabel.init()
        titleLB.textColor = UIColor.lightGray
        titleLB.text = "我是有底线的"
        view.addSubview(leftLine)
        view.addSubview(titleLB)
        view.addSubview(rightLine)
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        titleLB.translatesAutoresizingMaskIntoConstraints = false
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        let leftWidth = NSLayoutConstraint.init(item: leftLine, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60.0)
        let leftHeight = NSLayoutConstraint.init(item: leftLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.5)
        let leftRight = NSLayoutConstraint.init(item: leftLine, attribute: .right, relatedBy: .equal, toItem: titleLB, attribute: .left, multiplier: 1.0, constant: 0.0)
        let rightWidth = NSLayoutConstraint.init(item: rightLine, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60.0)
        let rightHeight = NSLayoutConstraint.init(item: rightLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.5)
        let rightLeft = NSLayoutConstraint.init(item: rightLine, attribute: .left, relatedBy: .equal, toItem: titleLB, attribute: .right, multiplier: 1.0, constant: 0.0)
        let titleCenterX = NSLayoutConstraint.init(item: titleLB, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let titleCenterY = NSLayoutConstraint.init(item: titleLB, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        view.addConstraints([leftWidth, leftRight, leftHeight,titleCenterX, titleCenterY, rightWidth, rightLeft, rightHeight])
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint.init(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerY = NSLayoutConstraint.init(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.addConstraints([centerX, centerY])
        return view
    }()
    
    public var refreshingHeight: CGFloat = 40.0
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: refreshingHeight))
        self.backgroundColor = UIColor.clear
//        self.backgroundColor = UIColor.red
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
