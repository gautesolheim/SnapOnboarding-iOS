import UIKit

@IBDesignable class SnapOnboardingUnderlinedButton: UIButton {

    private var attributes = [String: AnyObject]()
    
    @IBInspectable var underlineColor: UIColor? {
        didSet {
//            attributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
//            attributes[NSUnderlineColorAttributeName] = underlineColor
        }
    }
    
    override func drawRect(rect: CGRect) {
        let contextRef = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(contextRef, underlineColor?.CGColor)
        
        CGContextMoveToPoint(contextRef, 0, self.bounds.size.height - 1);
        CGContextAddLineToPoint(contextRef, self.bounds.size.width, self.bounds.size.height - 1);

        CGContextStrokePath(contextRef);
        
        super.drawRect(rect);
    }
    
    func updateText(text: String?) {
        if let text = text {
            setAttributedTitle(NSMutableAttributedString(string: text, attributes: attributes), forState: .Normal)
        }
    }
    
    private func createDefaultParagraphStyle() -> NSMutableParagraphStyle {
        let defaultParagraphStyle = NSMutableParagraphStyle()
        defaultParagraphStyle.alignment = NSTextAlignment.Center
        return defaultParagraphStyle
    }

}
