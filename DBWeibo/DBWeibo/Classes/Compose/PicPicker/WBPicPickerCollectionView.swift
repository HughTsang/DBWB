//
//  WBPicPickerCollectionView.swift
//  DBWeibo
//
//  Created by zenghz on 2017/5/4.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

fileprivate let picPickerCell = "picPickerCell"
fileprivate let edgeMargin: CGFloat = 15

class WBPicPickerCollectionView: UICollectionView {

    // MARK: - 定义属性
    var images: [UIImage] = [UIImage]() {
        didSet {
        
            reloadData()
        }
    }
    
    
    /// 系统回调函数
    override func awakeFromNib() {
        
        // 1.设置layout
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = edgeMargin
        layout.minimumLineSpacing = edgeMargin
        
        // 2.设置collectionView的属性
        register(UINib(nibName: "WBPicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
        
        // 3.设置collectionView的内边距
        contentInset = UIEdgeInsetsMake(edgeMargin, edgeMargin, 0, edgeMargin)
    }
  
}

extension WBPicPickerCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! WBPicPickerViewCell
        
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        return cell
    }
}
