//
//  WBPicCollectionView.swift
//  DBWeibo
//
//  Created by zenghz on 2017/4/27.
//  Copyright © 2017年 Personal. All rights reserved.
//  微博配图

import UIKit
import SDWebImage

class WBPicCollectionView: UICollectionView {

    // MARK: - 定义属性
    var picURLs: [URL] = [URL]() {
        didSet {
            
            self.reloadData()
        }
    }
    
    var bmiddle_pic: String? {
        didSet {
            picURLs.removeAll()
            guard let url = URL(string: bmiddle_pic ?? "") else {
                self.reloadData()
                return
            }
            picURLs.append(url)
            self.reloadData()
        }
    }
    
    // MARK: - 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
    }
    
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension WBPicCollectionView : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! WBPicCollectionViewCell
        
        // 2.给cell设置数据
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 1.获取通知需要传递的参数
        let userInfo = [ShowPhotoBrowserIndexKey : indexPath, ShowPhotoBrowserUrlsKey : picURLs] as [String : Any]
        
        // 2.发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNoti), object: self, userInfo: userInfo)
    }
}

// MARK: - AnimatorPresentedDelegate
extension WBPicCollectionView: AnimatorPresentedDelegate {
    
    func startedRect(indexPath: IndexPath) -> CGRect {
        
        // 1.获取cell
        let cell = self.cellForItem(at: indexPath) as! WBPicCollectionViewCell
        
        // 2.获取cell的frame
        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        
        // 3.返回起frame
        return startFrame
    }
    
    func endRect(indexPath: IndexPath) -> CGRect {
        
        // 1.获取该位置的Image对象
        let picURL = picURLs[indexPath.item]
        guard let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString) else {
            return CGRect.zero
        }
        
        // 2.计算结束后的frame
        let x: CGFloat = 0
        let width: CGFloat = UIScreen.main.bounds.width
        let height: CGFloat = width / image.size.width * image.size.height
        var y: CGFloat = 0
        if height > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func imageView(indexPath: IndexPath) -> UIImageView {
        
        // 1.创建UIImageView对象
        let imageView = UIImageView()
        
        // 2.获取该位置的Image对象
        let picURL = picURLs[indexPath.item]
        guard let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString) else {
            return imageView
        }
        
        //设置imageView的属性
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}

// MARK: - 自定义Cell
class WBPicCollectionViewCell : UICollectionViewCell {
    
    // MARK: - 定义属性
    var picURL: URL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            
            iconView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    // MARK: - 控件属性
    @IBOutlet weak var iconView: UIImageView!

}


