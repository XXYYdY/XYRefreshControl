//
//  ViewController.swift
//  xyrefresh
//
//  Created by yang on 2019/10/9.
//  Copyright © 2019 yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var mTabelView: UITableView = {
        let tableView = UITableView.init(frame: UIScreen.main.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var datas:[String] = ["1","2","3","4","5","6","7","8","9"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.mTabelView)
        self.title = "xyrefresh"
//        component: XYBallFlashRefreshHeaderComponent.init(),
        self.mTabelView.xy_header = XYRefreshHeader.init(component: XYBallFlashRefreshHeaderComponent.init(), model: XYRefreshHeader.Model.alawaysSuck, action: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self!.datas = ["1","2","3","4","5","6","7","8","9"]
                self!.mTabelView.reloadData()
                self!.mTabelView.xy_header?.endRefreshing()
            })
        })
        
        self.mTabelView.xy_footer = XYRefreshFooter.init(action: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                let lastIndex = Int(self!.datas.last!)!
                for index in 1...10 {
                    self!.datas.append("\(lastIndex + index)")
                }
                self!.mTabelView.reloadData()
                self!.mTabelView.xy_footer?.endRefreshing()
            })
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if #available(iOS 11, *) {
                
                print("keyWindow \(UIApplication.shared.keyWindow!.rootViewController!.view.safeAreaInsets) \n view.safeAreaInsets:\(self.view.safeAreaInsets) \n adjustedContentInset:\(self.mTabelView.adjustedContentInset) \n contentInset \(self.mTabelView.contentInset) \n contentOffset \(self.mTabelView.contentOffset)")
            }else {
                
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "test")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "test")
        }
        cell!.textLabel?.text = datas[indexPath.row]
        return cell!
    }
    
}

