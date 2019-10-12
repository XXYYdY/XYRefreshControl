//
//  UIScrollView+XYRefresh.swift
//  eltx_driver
//
//  Created by yang on 2019/9/21.
//  Copyright © 2019 yang. All rights reserved.
//
import UIKit

//MARK:-------Extension
let xyHeaderID = UnsafeRawPointer.init(bitPattern: "xyHeaderID".hashValue)!
let xyFooterID = UnsafeRawPointer.init(bitPattern: "xyFooterID".hashValue)!

public extension UIScrollView {
    var xy_header: XYRefreshHeader? {
        set {
            if newValue != nil {
                objc_setAssociatedObject(self, xyHeaderID, newValue!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                newValue!.initState()
                newValue!.layer.zPosition = -999
                self.addSubview(newValue!)
                for subView in self.subviews {
                    print(subView)
                }
            }
        }
        get {
            return objc_getAssociatedObject(self, xyHeaderID) as? XYRefreshHeader
        }
    }
    
    var xy_footer: XYRefreshFooter? {
        set {
            if newValue != nil {
                objc_setAssociatedObject(self, xyFooterID, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                newValue!.initState()
                self.addSubview(newValue!)
            }
        }
        get {
            return objc_getAssociatedObject(self, xyFooterID) as? XYRefreshFooter
        }
    }
//    //MARK:-------header
//    func stopHeaderRefresh() {
//        self.xy_header?.endRefersh()
//    }
//    
//    func beginHeaderRefreshing() {
//        self.xy_header?.startRefreshing()
//    }
//    
//    //MARK:-------footer
//    func stopFooterRefresh() {
//        self.xy_footer?.endRefersh()
//    }
//    
//    func beginFooterRefreshing() {
//        self.xy_footer?.startRefreshing()
//    }
//    
//    func resetNoMoreData() {
//        self.xy_footer?.resetNoMoreData()
//    }
//    
//    func noMoreData() {
//        self.xy_footer?.noMoreData()
//    }
}

//extension UIScrollView {

//    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "contentOffset" {
//            let contentOffset = self.contentOffset
//            let inset = self.contentInset
//            let maxY = -(self.contentInset.top + self.xy_header!.component!.refreshingHeight)
//            let offsetY = contentOffset.y
//
//            let suck = inset.top + self.xy_header!.component!.refreshingHeight
//            if offsetY <= -suck {
//                //吸顶
//                var newFrame = self.xy_header!.frame
//                newFrame.origin.y = inset.top
//                self.xy_header!.frame = newFrame
//
//            }else {
//                //跟随
//                var newFrame = self.xy_header!.frame
//                newFrame.origin.y = -offsetY - self.xy_header!.component!.refreshingHeight
//                self.xy_header!.frame = newFrame
//            }
//        }
//    }
//}




