//
//  UILoadMoreControl.swift
//  jiaxin
//
//  Created by luo shaoxun on 16/5/30.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

import UIKit
import ChameleonFramework
import Sugar

let Drag_Min_Height = CGFloat(50)

protocol UILoadMoreControlDelegate :NSObjectProtocol {
    func loadMoreControlDidLoadMore(view:UILoadMoreControl);
}


class UILoadMoreControl: UIView, UILoadMoreControlDelegate{
    weak var delegate:UILoadMoreControlDelegate?
    var scrollView: UIScrollView? {
        didSet{
            originalInset = scrollView?.contentInset
        }
    }
    var activity: UIActivityIndicatorView!
    var bLoading = false
    var bFull = false
    var labelInfo: UILabel!
    var originalInset:UIEdgeInsets!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        setupView()
    }
    
    func setupView() {
        backgroundColor = UIColor.clear
        activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.center = CGPoint(x:SCREEN_WIDTH / 2, y:20)
        self.addSubview(activity)
        
        
        labelInfo = UILabel(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:Drag_Min_Height / 2))
        labelInfo.textAlignment = .center
        labelInfo.font = UIFont.systemFont(ofSize: 12)
        labelInfo.textColor = UIColor.gray
        labelInfo.text = "没有更多数据"
        self.addSubview(labelInfo)
        
        bLoading = false
        bFull = false
        labelInfo.isHidden = !bFull
    }
    
    func setTableFull(full:Bool) {
        delay(0.15) { [weak self] in
            if let strongSelf = self {
                strongSelf.bLoading = false;
            }
        }
       
        bFull = full;
        labelInfo.isHidden = !bFull;
    }
    
    func endLoadingAndFull(full:Bool) {
        activity.stopAnimating()
        if let temp = scrollView {
            temp.contentInset = originalInset
            if scrollView != nil {
                self.y = temp.contentSize.height > temp.height ? temp.contentSize.height : temp.height
            }
            setTableFull(full: full)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.y = scrollView.contentSize.height > scrollView.height ? scrollView.contentSize.height : scrollView.height
        checkScrollView(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView) {
        
    }
    
    func loadMoreControlDidLoadMore(view:UILoadMoreControl){
        if let delegate = delegate {
            delegate.loadMoreControlDidLoadMore(view: self);
        }
    }
    
    func checkScrollView(scrollView:UIScrollView) {
        if (bLoading || bFull) {
            return
        }
        
        if scrollView.contentOffset.y + scrollView.height > scrollView.contentSize.height + 40 {
            bLoading = true
            
            UIView.animate(withDuration: 0.25) {[weak self] in
                if let strongSelf = self {
                    strongSelf.activity.startAnimating()
                    strongSelf.scrollView = scrollView
                    strongSelf.scrollView!.contentInset = UIEdgeInsetsMake(0.0, 0.0, Drag_Min_Height, 0.0)
                }
            }
            
            if let delegate = delegate {
                delegate.loadMoreControlDidLoadMore(view: self)
            }
        }
    }
}
