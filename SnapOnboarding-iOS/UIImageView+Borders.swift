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
            layer.masksToBounds = radius > 0.0
        }
    }
    
}