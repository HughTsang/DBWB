//
//  WBHomeViewCell.swift
//  DBWeibo
//
//  Created by zenghz on 2017/4/26.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit
import SDWebImage

fileprivate let edgeMargin: CGFloat = 15
fileprivate let itemMargin: CGFloat = 10

class WBHomeViewCell: UITableViewCell {

    // MARK: - 控件属性
    @IBOutlet weak var iconView: UIImageView!       //头像
    @IBOutlet weak var verifiedView: UIImageView!   //认证图标
    @IBOutlet weak var screenNameLbl: UILabel!      //昵称
    @IBOutlet weak var vipView: UIImageView!        //VIP图标
    @IBOutlet weak var timeLbl: UILabel!            //发布时间
    @IBOutlet weak var sourceLbl: UILabel!          //来源
    @IBOutlet weak var contentLbl: HZLabel!         //正文
    @IBOutlet weak var picView: WBPicCollectionView!    //微博配图
    @IBOutlet weak var retweetedContentLbl: HZLabel!    //转发微博正文
    @IBOutlet weak var retweetedBgView: UIView!         //转发微博背景
    @IBOutlet weak var bottomToolView: UIView!          //底部工具栏

    // MARK: - 约束属性
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetedContentLblTopCons: NSLayoutConstraint!
    
    // MARK: - 自定义属性
    var viewModel: WBStatusViewModel? {
        didSet{
            
            // 1.nil值校验
            guard let viewModel = viewModel else {
                return
            }
            
            // 2.设置属性
            iconView.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            verifiedView.image = viewModel.verifiedImage
            screenNameLbl.text = viewModel.status?.user?.screen_name
            vipView.image = viewModel.vipImage
            timeLbl.text = viewModel.createdAtText
            if let sourceText = viewModel.sourceText {
                sourceLbl.text = "来自 " + sourceText
            }else {
                sourceLbl.text = nil
            }
            contentLbl.attributedText = FindEmoticon.shared.findAttrString(statusText: viewModel.status?.text, font: contentLbl.font)
            
            // 2.1.会员昵称橘色
            screenNameLbl.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            
            // 3.计算picView的宽度和高度的约束
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height
            
            // 4.将picURL数据传递给picView
            if viewModel.picURLs.count == 1 {
                picView.bmiddle_pic = viewModel.status?.retweeted_status == nil ? viewModel.status?.bmiddle_pic : viewModel.status?.retweeted_status?.bmiddle_pic
            }else {
                picView.picURLs = viewModel.picURLs
            }
            
            // 5.设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
                
                // 5.1.设置转发微博的正文
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name,
                    let retweetedContent = viewModel.status?.retweeted_status?.text {
                    let reweetedText = "@" + "\(screenName): " + retweetedContent
                    retweetedContentLbl.attributedText = FindEmoticon.shared.findAttrString(statusText: reweetedText, font: retweetedContentLbl.font)
                    
                    // 设置转发正文距离顶部的约束
                    retweetedContentLblTopCons.constant = 15
                }
                
                // 5.2.设置背景显示
                retweetedBgView.isHidden = false
                
            }else {
                retweetedContentLbl.text = nil
                retweetedBgView.isHidden = true
                retweetedContentLblTopCons.constant = 0
            }
            
            // 6.计算cell的高度
            if viewModel.cellHeight == 0 {
                
                // 6.1.强制布局
                layoutIfNeeded()
                
                // 6.2.获取底部工具栏的最大Y值
                viewModel.cellHeight = bottomToolView.frame.maxY
            }
             
        }
    }
    
    // MARK: - 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1.设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
        
        // 2.设置HZLabel的内容
//        contentLbl.matchTextColor = UIColor.cyan
        retweetedContentLbl.matchTextColor = UIColor.red
        
        // 3.监听HZLabel中内容的点击
        // 3.1.监听@XXX的点击
        contentLbl.userTapHandler = { (label, user, range) in

//            print(label)
            print(user)
//            print(range)
        }
        
        retweetedContentLbl.userTapHandler = { (label, user, range) in
            print(user)
        }
        
        // 3.2.监听链接的点击
        contentLbl.linkTapHandler = { (label, link, range) in
        
//            print(label)
            print(link)
//            print(range)
        }
        
        retweetedContentLbl.linkTapHandler = { (label, link, range) in
            print(link)
        }
        
        // 3.3.监听话题的点击
        contentLbl.topicTapHandler = { (label, topic, range) in
            
//            print(label)
            print(topic)
//            print(range)
        }
        
        retweetedContentLbl.topicTapHandler = { (label, topic, range) in
            print(topic)
        }
    }
}

// MARK: - 计算方法
extension WBHomeViewCell {
    
    /// 计算picView的宽度和高度的约束
    fileprivate func calculatePicViewSize(count: Int) -> CGSize {
        
        // 1.没有配图
        if count == 0 {
            
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        // 有配图需要该约束有值
        picViewBottomCons.constant = 10
        
        // 取出picView对应的Layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // 2.计算出来imageView的宽高
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3

        // 3.单张配图
        if count == 1 {
            
            // 3.1.取出图片
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: viewModel?.picURLs.first?.absoluteString)
            
            guard let tempImage = image else {
                return CGSize(width: imageViewWH, height: imageViewWH)
            }
            
            // 3.2.设置一张图片时候的layout的itemSize
            layout.itemSize = CGSize(width: tempImage.size.width * 2, height: tempImage.size.height * 2)
            
            return CGSize(width: tempImage.size.width * 2, height: tempImage.size.height * 2)
        }
        
        // 设置其他张图片时layout的itemSize
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        // 4.四张配图
        if count == 4 {
            
            let picViewWH = imageViewWH * 2 + itemMargin + 1
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        // 5.其他张配图  rows = (count- 1) / 3 + 1
        // 5.1.计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        
        // 5.2.计算picView的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        
        // 5.3.计算picView的宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
}
