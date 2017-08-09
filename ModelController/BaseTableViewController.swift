//
//  BaseTableViewController.swift
//  swiftLive
//
//  Created by GaoFei on 16/3/15.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

import StatefulViewController
import SwiftyJSON
//Bug fix：只支持竖屏
class BaseTableViewController: VXXBaseViewController,StatefulViewController,ModelDelegate,UILoadMoreControlDelegate,LiveRoomVCDelegate{
    lazy var tableView: UITableView = {
        [unowned self] in
        let temp  = UITableView(frame: self.view.bounds, style: self.tableViewStyle)
        
        self.view.addSubview(temp)
        return temp
    }()
    
    lazy var param = [String:AnyObject]()
    
    var model:Model?
    var loadmoreControl: UILoadMoreControl?
    
    var dataSource:BaseTableViewDataSource?{
        didSet{
            //设置dataSource 以后需要刷新请求数据
            dataSource?.model.delegate = self
            model = dataSource?.model
            tableView.dataSource = dataSource
            tableView.delegate = delegate
            refresh()
        }
    }
    
    let topRefreshControl = UIRefreshControl()
    
    lazy var delegate:BaseTableViewDelegate = self.createDelegate()
    var tableViewStyle:UITableViewStyle = .plain
    //决定自定义行高方法是否运行
    var variableHeightRows = true
    
    func liveVCNeedClose(liveVC: LiveRoomViewController,isAnimation:Bool) {
        
    }
    
    //刷新数据
    func refresh(){
        
        if (lastState == .Loading) { return }
        startLoading (completion: {[unowned self] in
            self.showLoading()
        })
        
        dataSource?.model.load(cachePolicy: .useProtocolCachePolicy, more: false, parameters: param)
        
    }
    
    func needLoadMore() ->(Bool) {
        return false
    }
    
    //UILoadMoreControl
    func createLoadMoreControlWithFull(full:Bool) ->(Bool) {
        if loadmoreControl == nil {
            loadmoreControl = UILoadMoreControl(frame: CGRect.init(x: 0, y: tableView.height, width: tableView.width, height: tableView.height))
            loadmoreControl?.delegate = self
            tableView.addSubview(loadmoreControl!)
            loadmoreControl?.setTableFull(full: full)
            return false
        }
        return true
    }
    
    func endLoadingWithFull(full:Bool) {
        loadmoreControl?.endLoadingAndFull(full: full)
    }
    
    func cancelLoadMoreControl() {
        if loadmoreControl != nil {
            loadmoreControl?.removeFromSuperview()
            loadmoreControl = nil
        }
    }
    
    
    //加载更多
    func loadMoreControlDidLoadMore(view:UILoadMoreControl) {
        if (currentState == .Loading) { return }
        startLoading(completion: {[unowned self] in
            self.showLoading()
        })
        dataSource?.model.load(cachePolicy: .useProtocolCachePolicy, more: true, parameters: param)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        setupTableView()
        view.backgroundColor = kBackgroupColor
        registerCell()
        //占位图
        setupPlaceholderViews()
    }
    
    
    func setupTableView() {
        tableView.backgroundColor = kBackgroupColor
        tableView.height = SCREEN_HEIGHT - 64
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = kLineColor
    }
    
    func showLoading() {
    }
    
    //注册cell
    func registerCell() {
        
    }
    
    //下拉刷新
    func setupTopRefreshControl() {
        
        topRefreshControl.addTarget(self, action: #selector(BaseTableViewController.refresh), for: .valueChanged)
        
        tableView.addSubview(topRefreshControl)
    }
    
    func createDelegate ()->BaseTableViewDelegate{
        
        if(self.variableHeightRows){
            return BaseTableViewVarHeightDelegate(controller:self)
        }else{
            return BaseTableViewDelegate(controller: self)
        }
    }
    
    //选中行
    func didSelect(item:[String:JSON],AtIndexPath indexPath:NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
   //cell消失
    func cellDidDisappear(indexPath:NSIndexPath,didEndDisappearCell cell: UITableViewCell){
        
    }
    func modelDidFinishLoad(model: Model) {
        
        dataSource?.tableView(DidLoadModel: tableView)
        tableView.reloadData()
        topRefreshControl.endRefreshing()
        endLoading()
        
        if (needLoadMore()) {
           let tempModel = model as! PageModel
            if tempModel.items.count > 0 {
                if createLoadMoreControlWithFull(full: tempModel.finished) {
                    endLoadingWithFull(full: tempModel.finished)
                }
            }
        }
    }
    
    func modeldidFailLoad(model: Model, error: NSError) {
        
        if errorView == nil {
            return
        }
        
        (errorView as! PlaceholderView).tipTitleLabel.text = error.localizedDescription
        topRefreshControl.endRefreshing()
        endLoading(error:error)
        
        if (needLoadMore()) {
            endLoadingWithFull(full: (model as! PageModel).finished)
        }
    }
    
    func handleErrorWhenContentAvailable(error: Error) {
        if((error as NSError).code == -999) {//取消请求
            return
        }
         let alertController = UIAlertController(title: "", message: (error as NSError).localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
}

//PlaceholderViews
extension BaseTableViewController {
    
    func setupPlaceholderViews() {
        createEmptyPlace()
        createErrorPlace()
        createLoadingPlace()
    }
    
    func createLoadingPlace() {
        let loading = Bundle.main.loadNibNamed("PlaceholderView", owner: self, options: nil)?.first as! PlaceholderView
        loading.frame = reactForPlace()
        loading.tipDescLabel.isHidden = true
        loading.tipImageView.image = imageForLoading()
        loading.tipTitleLabel.text = titleForLoading()
        loadingView = loading
    }
    
    func createErrorPlace() {
        let error =  Bundle.main.loadNibNamed("PlaceholderView", owner: self, options: nil)?.first as! PlaceholderView
        error.tipImageView.image = imageForErro()
        error.tipTitleLabel.text = titleForErro()
        error.frame = reactForPlace()
        error.activityView.isHidden = true
        error.tapGestureRecognizer.addTarget(self, action: #selector(BaseTableViewController.refresh))
        errorView = error
    }
    
    func createEmptyPlace() {
        let empty =  Bundle.main.loadNibNamed("PlaceholderView", owner: self, options: nil)?.first as! PlaceholderView
        empty.tipImageView.image = imageForEmpty()
        empty.tipTitleLabel.text = titleForEmpty()
        empty.tipTitleLabel.text = ""
        empty.tipDescLabel.text = titleForEmpty()
        empty.frame = reactForPlace()
        empty.activityView.isHidden = true
        empty.tapGestureRecognizer.addTarget(self, action: #selector(BaseTableViewController.refresh))
        emptyView = empty
    }
    
    func reactForPlace() -> CGRect {
        return view.frame
    }
    
    func titleForLoading() -> String {
        return "加载中..."
    }
    
    func titleForEmpty() -> String {
        return "暂无记录"
    }
    
    func titleForErro() -> String {
        return "出错啦"
    }
    
    func imageForEmpty() -> UIImage? {
        return UIImage.init(named: "kong")
    }
    
    func imageForLoading() -> UIImage? {
        return nil
    }
    
    func imageForErro() -> UIImage? {
        return   UIImage.init(named: "placeholederError")
    }
}

extension BaseTableViewController {
    
    func hasContent() -> Bool {
        if let temp  = dataSource {
            return temp.hasContent()
        }else{
            return false
        }
    }
}
