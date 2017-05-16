import UIKit

extension UIBarButtonItem {
    
    
     /// 快速创建一个UIBarButtonItem
     convenience init(imageName: String, highlightImageName: String) {

        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: highlightImageName), for: .highlighted)
        btn.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        
        self.init(customView: btn)
    }
    
}
