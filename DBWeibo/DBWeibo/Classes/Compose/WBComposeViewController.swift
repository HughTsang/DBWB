//
//  WBComposeViewController.swift
//  DBWeibo
//
//  Created by zenghz on 2017/5/3.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBComposeViewController: UIViewController {

    // MARK: - 控件属性
    @IBOutlet weak var composeTextView: WBComposeTextView!
    @IBOutlet weak var picPickerView: WBPicPickerCollectionView!
    
    // MARK: - 约束属性
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewHeightCons: NSLayoutConstraint!
    
    // MARK: - 懒加载属性
    fileprivate lazy var titleView: WBComposeTitleView = WBComposeTitleView()
    fileprivate lazy var images: [UIImage] = [UIImage]()
    fileprivate lazy var emoticonVc: EmoticonsController = EmoticonsController {[weak self] (emoticon) in
        self?.composeTextView.insertEmoticon(emoticon: emoticon)
        self?.textViewDidChange(self!.composeTextView)
    }
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.设置导航栏
        setupNavigationBar()

        // 2.监听通知
        setupNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        composeTextView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 设置UI
extension WBComposeViewController {
    
    fileprivate func setupNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(WBComposeViewController.closeItemClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(WBComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    
    fileprivate func setupNotifications() {
    
        // 监听键盘的弹出
        NotificationCenter.default.addObserver(self, selector: #selector(WBComposeViewController.keyboardWillChangeFrame(noti:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // 监听添加照片的点击
        NotificationCenter.default.addObserver(self, selector: #selector(WBComposeViewController.addPhotoClick), name: NSNotification.Name(rawValue: PicPickerAddPhotoNoti), object: nil)

        // 监听删除照片的点击
        NotificationCenter.default.addObserver(self, selector: #selector(WBComposeViewController.removePhotoClick(noti:)), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNoti), object: nil)
    }
    
}

// MARK: - 事件监听函数
extension WBComposeViewController {

    @objc fileprivate func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func sendItemClick() {
        
        // 1.获取发送微博的微博正文
        let statusText = self.composeTextView.getEmoticonString()
        
        // 2.定义回调的闭包
        let finishedCallback = { (isSuccess: Bool) in
            
            self.composeTextView.resignFirstResponder()
            
            if isSuccess {
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                self.dismiss(animated: true, completion: nil)
            } else {
                SVProgressHUD.showError(withStatus: "发布失败")
            }
        }
        
        // 2.获取用户选中的图片
        if let image = images.first {
            WBNetworkTools.shareInstance.sendStatus(statusText: statusText, image: image, isSuccess: finishedCallback)
        } else {
            WBNetworkTools.shareInstance.sendStatus(statusText: statusText, isSuccess: finishedCallback)
        }
        
    }
    
    
    // 监听键盘
    @objc fileprivate func keyboardWillChangeFrame(noti: NSNotification) {
    
//        HZLog(noti.userInfo)
        // 1.获取动画执行时间   UIKeyboardAnimationDurationUserInfoKey
        let duration = noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        // 2.获取键盘最终Y值   UIKeyboardFrameEndUserInfoKey
        let endFrame = (noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.minY
        
        // 3.计算工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - y
        
        // 4.执行动画
        toolBarBottomCons.constant = margin
        UIView.animate(withDuration: duration) { 
           self.view.layoutIfNeeded()
        }
    }

    @IBAction func picPickerBtnClick() {
        
        // 推出键盘
        composeTextView.resignFirstResponder()
        
        picPickerViewHeightCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func emoticonBtnClick() {
    
        // 1.推出键盘
        composeTextView.resignFirstResponder()

        // 2.切换键盘
        composeTextView.inputView = composeTextView.inputView != nil ? nil : emoticonVc.view
        
        // 3.弹出键盘
        composeTextView.becomeFirstResponder()
    }
    
}

// MARK: - 添加照片和删除照片的事件
extension WBComposeViewController {
    
    @objc fileprivate func addPhotoClick() {
    
        // 1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        
        // 2.创建照片选择控制器
        let ipc = UIImagePickerController()
        
        // 3.设置照片源
        ipc.sourceType = .photoLibrary
        
        // 4.设置代理
        ipc.delegate = self
        
        // 5.弹出控制器
        present(ipc, animated: true, completion: nil)
    }
    
    @objc fileprivate func removePhotoClick(noti: NSNotification) {
        
        // 1.获取image对象
        guard let image = noti.object as? UIImage else {
            return
        }
        
        // 2.获取image对象所在的下标
        guard let index = images.index(of: image) else {
            return
        }
        
        // 3.将图片从数组中删除
        images.remove(at: index)
        
        // 4.重新赋值collectionView新的数据源
        picPickerView.images = images
    }
}

// MARK: - UITextViewDelegate
extension WBComposeViewController : UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.composeTextView.placeHolderLbl.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        composeTextView.resignFirstResponder()
        
    }
}

// MARK: - UIImagePickerControllerDelegate
extension WBComposeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 1.获取选中的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 2.将选中的照片添加到数组中
        images.append(image)
        
        // 3.将数组赋值给collectionView,展示数据
        picPickerView.images = images
        
        // 4.退出
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        HZLog("取消")
    }
}
