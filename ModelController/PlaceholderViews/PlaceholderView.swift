//
//  PlaceholderView.swift
//  jiaxin
//
//  Created by GaoFei on 16/4/23.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

import UIKit

class PlaceholderView: UIView {
    @IBOutlet weak var tipTitleLabel: UILabel!
    @IBOutlet weak var tipDescLabel: UILabel!
    @IBOutlet weak var tipImageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
