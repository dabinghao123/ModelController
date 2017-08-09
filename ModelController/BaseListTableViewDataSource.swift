//
//  BaseTableViewDataSource.swift
//  swiftLive
//
//  Created by GaoFei on 16/3/16.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseListTableViewDataSource: BaseTableViewDataSource {
    lazy var items = [JSON]()
    var index = 0
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            if self.viewController?.isKind(of:VXXHomeViewController.classForCoder()) == true {
    
                var index = 0
                for json in items {
                    if json["cellClass"] == "LiveListCell" {
                        index += 1
                    }
                }
                print("======================")
                print("cell的个数\((items.count - index) + (index + 1) / 2)")
                print("======================")
            return (items.count - index) + (index + 1) / 2
            }else{
                
                return items.count
            }
        
    }

    
    func  updateTableView() {
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        
        let identifier = items[indexPath.row]["cellClass"].stringValue
      
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath as IndexPath)
        
        if(cell is BaseTableViewCell){
            
            (cell as! BaseTableViewCell).viewController = viewController
            //给自定义金额cell设置文本代理
            
            if identifier == "MyWalletCustomCell" {
                (cell as! MyWalletCustomCell).customMoney.delegate = viewController as! MyWalletViewController
                
                //标记cell
                (viewController as! MyWalletViewController).customCell = cell
                
                //增加Done键
                (cell as! MyWalletCustomCell).customMoney.inputAccessoryView = (cell as! MyWalletCustomCell).addToolBar()
                
            }
            
            //MyWalletExchangeCell选中状态处理
            //FIXME:日后再改
//            if identifier == "MyWalletExchangeCell" {
//                (cell as! MyWalletExchangeCell).isSelected = isSelected
//            }
            //选择银行卡界面cell选择处理
//            if identifier == "BankCardCell" || identifier == "NewBankCardCell" {
//                if identifier == "BankCardCell" {
//                    
//                    (cell as! BankCardCell).isSelected = isSelected
//                }else{
//                (cell as! NewBankCardCell).isSelected = isSelected
//                }
//            }

            //选择银行界面cell选择处理
            //FIXME:日后再改
//            if identifier == "BankCell" {
//                (cell as! BankCell).isSelectedCell = isSelected
//            }
//            
            let reuseIdentifier:NSString = cell.reuseIdentifier! as NSString
            
            if reuseIdentifier.isEqual(to: "LiveListCell") {
//                
//                if index < items.count{
//                    
//                    if index == 0 {
//                        index = indexPath.row
//                        (cell as! BaseTableViewCell).dataArray.append(items[index].dictionaryValue)
//                        index += 1
//                        
//                        if index < items.count{
//                        (cell as! BaseTableViewCell).dataArray.append(items[index].dictionaryValue)
//                        }
//                        index += 1
//                        
//                        (cell as! LiveListCell).dataSource = (cell as! BaseTableViewCell).dataArray
//                    }else{
//                        
//                            
//                            (cell as! BaseTableViewCell).dataArray.append(items[index].dictionaryValue)
//                            index += 1
//                        if index < items.count{
//                            (cell as! BaseTableViewCell).dataArray.append(items[index].dictionaryValue)
//                        }
//                            index += 1
//                        
//                            (cell as! LiveListCell).dataSource = (cell as! BaseTableViewCell).dataArray
//                        
//                    }
//                    
//                    
//                }
                
            }else{
                
                (cell as! BaseTableViewCell).info = items[indexPath.row].dictionaryValue
            }
            (cell as! BaseTableViewCell).index = indexPath.row
        if reuseIdentifier.isEqual(to: "SalePriceCell")
           {
                 if (cell as! BaseTableViewCell).index == 0
                 {
                (cell as! SalePriceCell).FirstLabel.layer.cornerRadius = 8
                (cell as! SalePriceCell).FirstLabel.layer.masksToBounds = true
                (cell as! SalePriceCell).FirstLabel.isHidden = false
                 }else{
                     (cell as! SalePriceCell).FirstLabel.isHidden = true
                }
            }
        }
        
        return cell
    }
    
    override func objectForRowAtIndexPath(indexPath: NSIndexPath) -> [String : JSON]? {
                if (indexPath.row < items.count) {
                    return items[indexPath.row].dictionaryValue;
                } else {
                    return nil;
                }
    }

    override func hasContent() -> Bool {
        return items.count > 0
    }
}
