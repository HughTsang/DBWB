//
//  WBPicPickerViewCell.swift
//  DBWeibo
//
//  Created by zenghz on 2017/5/4.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class WBPicPickerViewCell: UICollectionViewCell {

    // MARK: - 控件属性
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var removePhotoBtn: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    
    // MARK: - 定义属性
    var image: UIImage? {
        didSet {
        
            let  ret = image != nil
            if ret {
                photoView.image = image
                addPhotoBtn.isUserInteractionEnabled = false
            }else {
                photoView.image = nil
                addPhotoBtn.isUserInteractionEnabled = true
            }
            
            addPhotoBtn.isUserInteractionEnabled = !ret
            removePhotoBtn.isHidden = !ret
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

// MARK: - 事件监听
extension WBPicPickerViewCell {
    
    @IBAction func addPhotoClick(_ sender: Any) {
        
        // 发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNoti), object: nil)
    }
    
    @IBAction func removePhotoClick() {
        
        // 发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerRemovePhotoNoti), object: photoView.image)
    }
    
}
