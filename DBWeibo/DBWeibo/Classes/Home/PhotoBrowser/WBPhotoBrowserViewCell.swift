//
//  WBPhotoBrowserViewCell.swift
//  DBWeibo
//
//  Created by zenghz on 2017/5/15.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserViewCellDelegate: NSObjectProtocol {
    func imageViewClick()
}

class WBPhotoBrowserViewCell: UICollectionViewCell {
    
    // MARK: - 定义属性
    var picURL: URL? {
        didSet {
            setupContent(picURL: picURL)
        }
    }
    
    var delegate: PhotoBrowserViewCellDelegate?
    
    // MARK: - 懒加载
    fileprivate lazy var scroll: UIScrollView = UIScrollView()
    fileprivate lazy var progressView: WBProgressView = WBProgressView()
    lazy var imageView: UIImageView = UIImageView()
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI
extension WBPhotoBrowserViewCell {
    
    fileprivate func setupUI() {
    
        // 1.添加子控件
        contentView.addSubview(scroll)
        scroll.addSubview(imageView)
        contentView.addSubview(progressView)
        
        // 2.设置Frame
        scroll.frame = contentView.bounds
        scroll.frame.size.width -= 20
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        
        // 3.设置控件的属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        
        // 4.监听图片点击
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(WBPhotoBrowserViewCell.photoClicked))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGes)
    }
}

// MARK: - 设置Cell的UI
extension WBPhotoBrowserViewCell {

    fileprivate func setupContent(picURL: URL?) {
        
        // 1.nil值校验
        guard let picURL = picURL else {
            return
        }
        
        // 2.取出Image对象
        guard let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: picURL.absoluteString) else {
            return
        }
        
        // 3.计算imageView的frame
        let x: CGFloat = 0
        let width = UIScreen.main.bounds.width
        let height = width / image.size.width * image.size.height
        
        var y: CGFloat = 0
        if height > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // 4.设置imageView的图片
        progressView.isHidden = false
        imageView.sd_setImage(with: getBigURL(smallURL: picURL), placeholderImage: image, options: [], progress: { (current, total, _) in
            
            self.progressView.progress = CGFloat(current) / CGFloat(total)
            
        }) { (_, _, _, _) in
            
            self.progressView.isHidden = true
        }
        
        // 5.设置scroll的滚动内容
        scroll.contentSize = CGSize(width: 0, height: height)
        scroll.bounces = false
    }
    
    private func getBigURL(smallURL: URL) -> URL {
    
        let smallURLString = smallURL.absoluteString
        //thumbnail bmiddle large
        let bigURLString = smallURLString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        
        return URL(string: bigURLString)!
    }

}

// MARK: - 事件监听
extension WBPhotoBrowserViewCell {

    @objc fileprivate func photoClicked() {
        
        delegate?.imageViewClick()
    }
}
