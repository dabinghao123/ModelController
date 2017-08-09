//
//  BaseTableViewCell.swift
//  swiftLive
//
//  Created by GaoFei on 16/3/15.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseTableViewCell: UITableViewCell {
    weak var viewController:BaseTableViewController?
    var index = -1
    var dataArray = [[String:JSON]]()
    var info:[String:JSON]?{
        didSet{
            self.setInfo()
        }
    }
    
    //对传入的数据进行绑定
    func setInfo () {
        
    }
    
    class func rowHeightForObject (tableView:UITableView,data:[String:JSON]) -> CGFloat {
        return -1.0
    }
}
