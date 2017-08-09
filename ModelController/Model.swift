//
//  ModelDelegate.swift
//  swiftLive
//
//  Created by GaoFei on 16/2/10.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK:Model
protocol Model{
    
    weak var delegate:ModelDelegate?{get set};
    
    func load(cachePolicy:NSURLRequest.CachePolicy,more:Bool,parameters: [String:AnyObject]);
}

extension Model{
    
    // MARK:State
    func didFinishLoad(){
        if let delegate = delegate {
            delegate.modelDidFinishLoad(model: self);
        }
    }
    
    func didFailLoadWithError(error:NSError){
        if let delegate = delegate {
            delegate.modeldidFailLoad(model: self,error: error);
        }
    }
}

// MARK:ModelDelegate
protocol ModelDelegate :NSObjectProtocol{
    
    func modelDidFinishLoad(model:Model);
    
    func modeldidFailLoad(model:Model,error:NSError);
}


class PageModel:NSObject,Model{
    
    weak var delegate:ModelDelegate?
    var count = 0
    lazy var items = [JSON]()
//    默认1000
    var limit = 1000
    var offset = 0
    var finished = false
    var request:VXXRequest!
    var first = true
    
    internal func load(cachePolicy: NSURLRequest.CachePolicy, more: Bool, parameters: [String : AnyObject]) {
        var temp = parameters
        if let tlimit = parameters["limit"] {
            temp["limit"] = tlimit
            limit = (temp["limit"]! as AnyObject).integerValue!
        }else{
            temp["limit"] = limit as AnyObject?
        }

        if(more){
            
        }else{
            offset = 1
            finished = false
        }
        
        temp["page"] = offset as AnyObject?
        
        guard let req  =  createRequest(parameters: temp) else {
            didFailLoadWithError(error: NSError(domain: "com.gaofei.error", code: 404, userInfo: nil))
            return
        }
        request = req
        request.perform(success: { [weak self] result in
            if let strongSelf = self {
                strongSelf.generateBeforeParamers(result: result)
                strongSelf.generateItems(result: result)
                strongSelf.generateLaterParamers(result: result)
                strongSelf.finished = strongSelf.judgeEndd(result: result)
                strongSelf.didFinishLoad()
            }
        }) { [weak self] error in
            if let strongSelf = self {
                var temp = NSError();
                
                if let errorModel = error.errorModel {
                    temp = NSError(domain: "com.qinxin.error", code: errorModel.status, userInfo: [NSLocalizedDescriptionKey:errorModel.msg])
                }
                ToolUntil.showAlertCommon(error)
                strongSelf.didFailLoadWithError(error: temp)
            }
        }
    }
    
    //判断是否还可以翻页
    func judgeEndd(result:ApiResult) ->Bool{
        let count = result.result.arrayValue.count
        return limit > count
    }
    
    func generateBeforeParamers(result:ApiResult) {
        if(offset == 1) {
            items.removeAll()
        }
    }
    
    //返回数据后对本地参数进行处理
    func generateLaterParamers(result:ApiResult) {
        let cache = result.result["cache"].intValue
        if cache != 1 {
            offset+=1
        }
    }

    //对返回数据进行处理
    func generateItems(result:ApiResult){
        items.append(contentsOf: result.result.arrayValue)
    }

    func createRequest(parameters: [String : AnyObject])->VXXRequest?{
        return nil;
    }
}
