//
//  WBHomeViewController.swift
//  DBWeibo
//
//  Created by zenghz on 2017/2/16.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class WBHomeViewController: WBBaseViewController {

    // MARK: - 懒加载属性
    fileprivate lazy var titleBtn: UIButton = WBTitleButton()
    //注意: 在懒加载中使用当前对象的属性或者调用方法,也需要加self
    //  两个地方需要使用self: 1>如果一个函数中出现歧义 2>在闭包中使用当前对象的属性和方法也需要加self
    fileprivate lazy var popverAnimator: WBPopverAnimator = WBPopverAnimator {[weak self] (presented) in
        
        self?.titleBtn.isSelected = presented
    }
    /// 微博数据
    fileprivate lazy var viewModels: [WBStatusViewModel] = [WBStatusViewModel]()
    /// 提示View
    fileprivate lazy var tipLabel: UILabel = UILabel()
    /// 转场代理
    fileprivate lazy var photoBrowserAnimator: WBPhotoBrowserAnimator = WBPhotoBrowserAnimator()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.没有登录时设置的内容
        visitorView.addRotationAnimation()
        if !isLogin {
            return
        }
        
        // 2.设置导航栏的内容
        setupNavigationBar()
        
        // 3.设置估算高度
        tableView.estimatedRowHeight = 200
        
        // 4.布局上下拉刷新控件
        setupHeaderView()
        setupFooterView()
        
        // 5.设置提示Label
        setupTipLabel()
        
        // 6.监听通知
        setupNotifications()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 设置UI界面
extension WBHomeViewController {

    /// 设置导航栏内容
    fileprivate func setupNavigationBar() {
    
        //1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "empty_default", highlightImageName: "empty_default")
        
        //2.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "empty_comment", highlightImageName: "empty_comment")
        
        //3.设置titleView
        titleBtn.setTitle(WBUserAccountViewModel.shareInstance.account?.screen_name, for: .normal)
        titleBtn.addTarget(self, action: #selector(WBHomeViewController.titleButtonClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
        
    }
    
    /// 布局Header
    fileprivate func setupHeaderView() {
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(WBHomeViewController.loadNewStatuses))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放刷新", for: .pulling)
        header?.setTitle("正在刷新...", for: .refreshing)
        
        self.tableView.mj_header = header
        
        self.tableView.mj_header.beginRefreshing()
    }
    
    /// 布局Header
    fileprivate func setupFooterView() {
    
        let footer = MJRefreshAutoStateFooter(refreshingTarget: self, refreshingAction: #selector(WBHomeViewController.loadMoreStatuses))
        
        tableView.mj_footer = footer
    }
    
    fileprivate func setupTipLabel() {
        
        // 1.将tipLabel添加到父控件中
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        
        // 2.设置tipLabel的frame
        tipLabel.frame = CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: 0)
        
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
        
    }
    
    fileprivate func setupNotifications() {
    
        NotificationCenter.default.addObserver(self, selector: #selector(WBHomeViewController.showPhotoBrowser(noti:)), name: NSNotification.Name(rawValue: ShowPhotoBrowserNoti), object: nil)
    }
}

// MARK: - 事件监听
extension WBHomeViewController {
    
    /// 标题按钮点击
    @objc fileprivate func titleButtonClick(titleBtn: WBTitleButton) {
        
        //1.创建弹出的控制器
        let popoverVC = WBPopoverViewController()
        
        //2.设置控制器的modal样式
        popoverVC.modalPresentationStyle = .custom
        
        //3.设置转场代理
        popverAnimator.presentedFrame = CGRect(x: 50, y: kNavBarHeight, width: 180, height: 250)
        popoverVC.transitioningDelegate = popverAnimator
        
        //4.弹出控制器
        present(popoverVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func showPhotoBrowser(noti: Notification) {
    
        // 0.取出数据
        let indexPath = noti.userInfo![ShowPhotoBrowserIndexKey] as! IndexPath
        let picURLs = noti.userInfo![ShowPhotoBrowserUrlsKey] as! [URL]
        let object = noti.object as! WBPicCollectionView
        
        // 1.创建控制器
        let photoBrowserVc = WBPhotoBrowserViewController(indexPath: indexPath, picURLs: picURLs)
        
        // 2.设置modal样式
        photoBrowserVc.modalPresentationStyle = .custom
        
        // 3.设置转场代理
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        
        // 4.设置动画的代理
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        
        // 5.以modal的形式弹出控制器
        present(photoBrowserVc, animated: true, completion: nil)
    }
}

// MARK: - 请求数据
extension WBHomeViewController {
    
    @objc fileprivate func loadNewStatuses() {
        
        loadStatuses(isNewData: true)
    }
    
    @objc fileprivate func loadMoreStatuses() {
        
        loadStatuses(isNewData: false)
    }
    
    fileprivate func loadStatuses(isNewData: Bool) {
        
        // 0.获取since_id / max_id
        var since_id = 0
        var max_id = 0
        
        if isNewData == true {
            since_id = viewModels.first?.status?.mid ?? 0
        }else {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id-1)
        }
        
        WBNetworkTools.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) { (result, error) in
            
            // 1.错误校验
            if error != nil {
                print(error!)
                return
            }
            
            // 2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            
            // 3.遍历微博对应的字典
            var tempViewModel = [WBStatusViewModel]()
            for statusDict in resultArray {
                
                let status = WBStatus(dict: statusDict)
                let viewModel = WBStatusViewModel(status: status)
                tempViewModel.append(viewModel)
            }
            
            // 4.将数据放入到成员变量的数组中
            self.viewModels = (isNewData == true) ? tempViewModel + self.viewModels : self.viewModels + tempViewModel
            
            // 4.缓存图片
            self.cacheImages(viewModels: tempViewModel)
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }
        
    }
    
    private func cacheImages(viewModels: [WBStatusViewModel]) {
        
        // 0.创建group
        let group = DispatchGroup()
        
        // 1.缓存图片
        for viewModel in viewModels {
            for picURL in viewModel.picURLs {
                
                group.enter()
                
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _) in
                    
                    group.leave()
                })
            }
        }
        
        // 2.刷新表格
        group.notify(queue: DispatchQueue.main) { 
            
            self.tableView.reloadData()
            
            // 显示提示的Label
            self.showTipLabel(count: viewModels.count)
        }
    }
    
    /// 显示提示的Label
    fileprivate func showTipLabel(count: Int) {
        
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count) 条新微博"
        
        UIView.animate(withDuration: 1.0, animations: { 
            
            self.tipLabel.frame.size.height = 32

        }) { (_) in
            
            UIView.animateKeyframes(withDuration: 1.0, delay: 1.5, options: [], animations: { 
                
                self.tipLabel.frame.size.height = 0
                
            }, completion: { (_) in
                
                self.tipLabel.isHidden = true
            })
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension WBHomeViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let viewModel = viewModels[indexPath.row]
        return viewModel.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //1.创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellID") as! WBHomeViewCell
        
        //2.给cell设置数据
        let viewModel = viewModels[indexPath.row]
        cell.viewModel = viewModel
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}





