//
//  EmojiIconController.swift
//
//  Created by zenghz on 2017/5/4.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

private let EmojiIconCellID = "EmojiIconCell"

class EmoticonsController: UIViewController {

    // MARK: - 定义属性
    var emoticonCallBack: (_ emoticon: Emoticon) -> ()
    
    // MARK: - 懒加载属性
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmojiIconCollectionViewLayout())
    fileprivate lazy var toolBar: UIToolbar = UIToolbar()
    fileprivate lazy var manager = EmoticonManager()
    
    // MARK: - 自定义构造函数
    init(emoticonCallBack: @escaping (_ emoticon: Emoticon) -> ()) {
        
        self.emoticonCallBack = emoticonCallBack
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

}

// MARK: - 设置UI界面
extension EmoticonsController {
    
    fileprivate func setupUI() {
    
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        // 2.设置子控件的frame
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        // 3.VFL添加约束
        // 3.1.水平方向约束
        let views = ["toolBar" : toolBar, "collectionView" : collectionView] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        // 3.2.垂直方向约束
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        // 4.准备collectionView
        prepareForCollectionView()
        
        // 5.准备toolBar
        prepareForToolBar()
    }
    
    private func prepareForCollectionView() {
        
        // 1.注册cell和设置数据源
        collectionView.register(EmoticonsCell.self, forCellWithReuseIdentifier: EmojiIconCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
    }
    
    private func prepareForToolBar() {
        
        // 1.定义toolBar中titles
        let titles = ["最近", "默认", "emoji"]
        
        // 2.遍历标题,创建item
        var index = 100
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(EmoticonsController.itemClick(item:)))
            item.tag = index
            index += 1
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        tempItems.removeLast()
        
        // 3.设置toolBar的items数组
        toolBar.items = tempItems
        
        toolBar.tintColor = UIColor.orange
    }
}

// MARK: - 事件监听
extension EmoticonsController {
    
    @objc fileprivate func itemClick(item: UIBarButtonItem) {
        
        // 1.获取点击的item的tag
        let section = item.tag - 100
        
        // 2.根据tag获取到当前组
        let indexPath = IndexPath(item: 0, section: section)
        
        // 3.滚动到对应的位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension EmoticonsController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let package = manager.packages[section]
        return package.emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiIconCellID, for: indexPath) as! EmoticonsCell
        
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        
        return cell
    }
    
    // 代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 1.取出点击的表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        
        // 2.将点击的表情插图最近分组中
        insertRecentlyEmoticon(emoticon: emoticon)
        
        // 3.将表情回调给外界控制器
        if emoticon.isEmpty != true {
            
            self.emoticonCallBack(emoticon)
        } 
    }
    
    private func insertRecentlyEmoticon(emoticon: Emoticon) {
        
        // 1.如果是空白表情或者是删除按钮,不需要插入
        if emoticon.isRemove || emoticon.isEmpty {
            return
        }
        
        // 2.删除一个表情
        if manager.packages.first!.emoticons.contains(emoticon) {
            // 原来有该表情
            let index = (manager.packages.first?.emoticons.index(of: emoticon))!
            manager.packages.first?.emoticons.remove(at: index)
        }else {
            // 原来没有这个表情
            manager.packages.first?.emoticons.remove(at: 19)
        }
        
        // 3.将emoticon插入到最近分组中
        manager.packages.first?.emoticons.insert(emoticon, at: 0)
    }
}

// MARK: - 自定义布局
class EmojiIconCollectionViewLayout : UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        // 1.计算ItemWH
        let itemWH = UIScreen.main.bounds.width / 7
        
        // 2.设置layout的属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        // 3.设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsetsMake(insetMargin, 0, insetMargin, 0)
        
    }
}
