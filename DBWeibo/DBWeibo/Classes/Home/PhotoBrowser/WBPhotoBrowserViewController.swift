//
//  WBPhotoBrowserViewController.swift
//  DBWeibo
//
//  Created by zenghz on 2017/5/15.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

private let PhotoBrowserCellId = "PhotoBrowserCellId"

class WBPhotoBrowserViewController: UIViewController {

    // MARK: - 定义属性
    var indexPath: IndexPath
    var picURLs: [URL]
    
    // MARK: - 懒加载属性
    fileprivate lazy var collection: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: WBPhotoBrowserCollectionViewLayout())
    fileprivate lazy var closeBtn: UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关 闭")
    fileprivate lazy var saveBtn: UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保 存")
    
    // MARK: - 自定义构造函数
    init(indexPath: IndexPath, picURLs: [URL]) {
        self.indexPath = indexPath
        self.picURLs = picURLs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 系统回调函数
    override func loadView() {
        super.loadView()
        
        view.frame.size.width += 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.设置UI界面
        setupUI()
        
        // 2.滚动到对应的图片
        collection.scrollToItem(at: indexPath, at: .left, animated: false)
    }

}

// MARK: - 设置UI界面内容
extension WBPhotoBrowserViewController {
    
    fileprivate func setupUI() {
    
        // 1.添加子控件
        view.addSubview(collection)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        // 2.设置Frame
        collection.frame = view.bounds
        closeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.bottom.equalTo(-20)
            maker.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-40)
            maker.bottom.equalTo(closeBtn.snp.bottom)
            maker.size.equalTo(closeBtn.snp.size)
        }
        
        // 3.设置collectionView的属性
        collection.register(WBPhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCellId)
        collection.dataSource = self
        
        // 4.监听按钮的点击
        closeBtn.addTarget(self, action: #selector(WBPhotoBrowserViewController.closeBtnClicked), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(WBPhotoBrowserViewController.saveBtnClicked), for: .touchUpInside)
    }
    
}

// MARK: - 事件监听
extension WBPhotoBrowserViewController {
    
    @objc fileprivate func closeBtnClicked() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func saveBtnClicked() {
        
        // 1.获取当前正在显示的image
        let cell = collection.visibleCells.first as! WBPhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        
        // 2.将image对象保存到相册中
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(WBPhotoBrowserViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    @objc private func image(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: AnyObject) {
        
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败!"
        } else {
            showInfo = "保存成功!"
        }
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}

// MARK: - UICollectionViewDataSource
extension WBPhotoBrowserViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCellId, for: indexPath) as! WBPhotoBrowserViewCell
        
        cell.picURL = picURLs[indexPath.item]
        cell.delegate = self
        
        return cell
    }
}

// MARK: - PhotoBrowserViewCellDelegate
extension WBPhotoBrowserViewController: PhotoBrowserViewCellDelegate {
    
    func imageViewClick() {
        closeBtnClicked()
    }
}


// MARK: - 遵守AnimatorDismissDelegate
extension WBPhotoBrowserViewController: AnimatorDismissDelegate {
    
    func indexPathForDismissView() -> IndexPath {
    
        // 1.获取当前正在显示的indexPath
        let cell = collection.visibleCells.first!
        
        return collection.indexPath(for: cell)!
    }

    func imageViewForDismissView() -> UIImageView {
        
        // 1.创建UIImageView对象
        let imageView = UIImageView()
        
        // 2.设置imageView的frame
        let cell = collection.visibleCells.first as! WBPhotoBrowserViewCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        
        // 3.设置imageView的属性
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}

// MARK: - 自定义布局
class WBPhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        // 1.设置itemSize
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        // 2.设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
