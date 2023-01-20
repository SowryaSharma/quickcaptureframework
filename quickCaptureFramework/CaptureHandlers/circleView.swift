import Foundation
import UIKit

extension UIView{
    
    public func makeCircleView(view: UIView){
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.borderWidth = 2
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.borderColor = UIColor.white.cgColor
    }
}
