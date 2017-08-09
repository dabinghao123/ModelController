//
//  BaseSectionTableViewDataSource.swift
//  jiaxin
//
//  Created by GaoFei on 16/4/21.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseSectionTableViewDataSource: BaseTableViewDataSource {
    lazy var items = [[JSON]]()//二维数组
    lazy var sections = [String]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                 return sections.count == 0 ? 0 : items[section].count
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        
        return sections.count == 0 ? 1 : sections.count
    }
  

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections.count == 0 ? "" : sections[section]

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                let cell = tableView.dequeueReusableCell(withIdentifier: items[indexPath.section][indexPath.row]["cellClass"].stringValue, for: indexPath as IndexPath)
                if(cell is BaseTableViewCell){
                    (cell as! BaseTableViewCell).viewController = self.viewController
                    (cell as! BaseTableViewCell).info = items[indexPath.section][indexPath.row].dictionaryValue
                }
                let identifier = items[indexPath.section][indexPath.row]["cellClass"].stringValue
                if identifier == "SalePriceCell" && indexPath.row == 1 {
                    (cell as! SalePriceCell).FirstLabel.isHidden = false
                    (cell as! SalePriceCell).FirstLabel.layer.cornerRadius = 8
                    (cell as! SalePriceCell).FirstLabel.layer.masksToBounds = true
                }
                if identifier == "SaleDetailViewCell" {
        
                    if self.viewController is SaleDetailViewViewController == true {
                    (self.viewController as! SaleDetailViewViewController).VideoCell = cell
                    }else{
                        (self.viewController as! SaleDetailWinerViewController).VideoCell = cell
                    }
                }
                        return cell
        
    }

    override func objectForRowAtIndexPath(indexPath: NSIndexPath) -> [String : JSON]? {
            let section = items[indexPath.section]
            return section[indexPath.row].dictionaryValue
    }

    override func hasContent() -> Bool {
        return items.count > 0
    }
}
