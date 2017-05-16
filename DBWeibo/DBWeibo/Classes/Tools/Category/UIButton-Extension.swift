import UIKit


// MARK: - UIButton扩展
extension UIButton {
    
    //Swift中类方法是已class开头的方法,类似于OC中+方法
    /*
    class func createButton(imageName: String, bgImageName: String) -> UIButton {
    
        let button = UIButton()
        
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        button.sizeToFit()
        
        return button
    }
     */
    
    /*
     便利构造函数
        1.便利构造函数通常都是写在extension里面
        2.便利构造函数init前面需要加上convenience
        3.在便利构造函数中需要明确的调用self.init()
     */
    //convenience: 使用convenience修饰的构造函数叫做便利构造函数
    //  便利构造函数通常用在对系统的类进行构造函数的扩充时使用
    /// 便利构造函数
    convenience init(imageName: String, bgImageName: String) {
        self.init()
        
        setImage(UIImage(named: imageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        sizeToFit()
    }
    
    convenience init(bgColor: UIColor, fontSize: CGFloat, title: String) {
        self.init()
        
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}

