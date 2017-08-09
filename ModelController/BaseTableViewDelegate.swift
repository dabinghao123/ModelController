//
//  BaseTableViewDelegate.swift
//  swiftLive
//
//  Created by GaoFei on 16/3/16.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

import UIKit

class BaseTableViewDelegate: NSObject, UITableViewDelegate {
    weak var controller:UIViewController?
    init(controller vc:UIViewController) {
        controller = vc
    }
  

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let temp =  controller as? BaseTableViewController{
            if let item = temp.dataSource?.objectForRowAtIndexPath(indexPath: indexPath as IndexPath as NSIndexPath) {
                temp.didSelect(item: item, AtIndexPath: indexPath as NSIndexPath)

            }
        }
    }
    
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let temp =  controller as? BaseTableViewController {
            if(temp.tableView == scrollView) {
                if(temp.loadmoreControl != nil) {
                    temp.loadmoreControl?.scrollViewDidScroll(scrollView: scrollView)
                }
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if let temp =  controller as? BaseTableViewController {
                if(temp.tableView == scrollView) {
                    if(temp.loadmoreControl != nil) {
                        temp.loadmoreControl?.scrollViewDidEndDragging(scrollView: scrollView)
                    }
                }
            }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
                if let temp = controller as? BaseTableViewController
                {
                    temp.cellDidDisappear(indexPath: indexPath as NSIndexPath, didEndDisappearCell: cell)
                }
    }

}
