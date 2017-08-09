//
//  BaseTableViewDataSource.swift
//  jiaxin
//
//  Created by GaoFei on 16/4/21.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ModelTableViewDataSource{
    func tableView(DidLoadModel tableView: UITableView)
}

class BaseTableViewDataSource: NSObject,UITableViewDataSource,ModelTableViewDataSource {
    lazy var model:Model = self.createModel()
    weak var viewController:BaseTableViewController?
    //标记cell是否选中
    var isSelected:Bool?
    
    init(vc:BaseTableViewController?) {
        self.viewController = vc
    }
    
    func createModel()->Model{
        return PageModel()
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(DidLoadModel tableView: UITableView) {
        
    }
    
    func hasContent() -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         return UITableViewCell()
    }

    func objectForRowAtIndexPath(indexPath:NSIndexPath)->[String:JSON]?{
        return nil
    }
    
    
}
