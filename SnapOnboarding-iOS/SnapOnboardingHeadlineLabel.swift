import UIKit

@IBDesignable class SnapOnboardingHeadlineLabel: UILabel {
    
    private var attributes = [String: AnyObject]()
    
    @IBInspectable var designableLineSpacing: CGFloat = 1 {
        didSet {
            let paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle ?? createDefaultParagraphStyle()
            paragraphStyle.lineSpacing = designableLineSpacing
            attributes[NSParagraphStyleAttributeName] = paragraphStyle
            updateText(text)
        }
    }
    
    func updateText(text: String?) {
        if let text = text {
            attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        }
    }
    
    private func createDefaultParagraphStyle() -> NSMutableParagraphStyle {
        let defaultParagraphStyle = NSMutableParagraphStyle()
        defaultParagraphStyle.alignment = NSTextAlignment.Center
        return defaultParagraphStyle
    }

}
