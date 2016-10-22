import UIKit
import SnapFonts_iOS

@IBDesignable class SnapOnboardingHeadlineLabel: UILabel {
    
    fileprivate var attributes = [String: AnyObject]()
    
    // NOTE: Cannot be named lineSpacing, as this will set an offset regardless of its value (possibly Xcode bug)
    @IBInspectable var lineSpacin: CGFloat = 1 {
        didSet {
            let paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle ?? createDefaultParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacin
            attributes[NSParagraphStyleAttributeName] = paragraphStyle
            updateText(text)
        }
    }
    
    @IBInspectable var header: String? {
        didSet {
            updateTextWithHeader(header, text: text)
        }
    }
    
    func updateText(_ text: String?) {
        if let text = text {
            attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
    
    func updateTextWithHeader(_ header: String?, text: String?) {
        if let text = text {
            updateAttributedTextWithHeader(header, text: NSMutableAttributedString(string: text))
        }
    }
    
    func updateAttributedTextWithHeader(_ header: String?, text: NSMutableAttributedString?) {
        if let header = header, let body = text {
            var headerAttributes = attributes
            headerAttributes[NSFontAttributeName] = SnapFonts.gothamRoundedMedium(ofSize: font.pointSize)
            
            let updatedText = NSMutableAttributedString(string: header, attributes: headerAttributes)
            updatedText.append(NSAttributedString(string: "\n"))
            
            body.addAttributes(attributes, range: NSRange(location: 0, length: body.length))
            updatedText.append(body)
            attributedText = updatedText
        }
    }
    
    fileprivate func createDefaultParagraphStyle() -> NSMutableParagraphStyle {
        let defaultParagraphStyle = NSMutableParagraphStyle()
        defaultParagraphStyle.alignment = NSTextAlignment.center
        return defaultParagraphStyle
    }

}
