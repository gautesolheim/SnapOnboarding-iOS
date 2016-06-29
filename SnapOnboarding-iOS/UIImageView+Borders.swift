import UIKit

extension UIImageView {
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(width) {
            layer.borderWidth = width
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return layer.borderColor != nil ? UIColor(CGColor: layer.borderColor!) : UIColor.clearColor()
        }
        set(color) {
            layer.borderColor = color.CGColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set(radius) {
            layer.cornerRadius = radius
            
            layer.shadowColor = UIColor.yellowColor().CGColor
            layer.shadowOffset = CGSize(width: 4, height: 4)
            layer.shadowOpacity = 1
            layer.shadowRadius = 3
        }
    }
    
}