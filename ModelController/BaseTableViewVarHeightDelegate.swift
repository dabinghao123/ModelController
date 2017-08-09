//
//  BaseTableViewVarHeightDelegate.swift
//  swiftLive
//
//  Created by GaoFei on 16/3/16.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

import UIKit
import SwiftyJSON
import UITableView_FDTemplateLayoutCell

class BaseTableViewVarHeightDelegate: BaseTableViewDelegate {

      func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
                if let data = (tableView.dataSource as! BaseTableViewDataSource).objectForRowAtIndexPath(indexPath: indexPath ) {
                    let className = data["cellClass"]!.stringValue
                    let height = NSObject.cellFromName(className: className).rowHeightForObject(tableView: tableView, data: data)
                    if height == -1 {
                        return   tableView.fd_heightForCell(withIdentifier: className, cacheByKey: indexPath as NSCopying!) {[unowned self] (cell) in
                            (cell as! BaseTableViewCell).viewController = self.controller as? BaseTableViewController
                            (cell as! BaseTableViewCell).info = data
                        }
                    }else{
                        return height
                    }
                }else{
                    return 0.0
                }
    }

}
