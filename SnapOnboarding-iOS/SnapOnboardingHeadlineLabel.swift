import UIKit
import SnapFonts_iOS

@IBDesignable class SnapOnboardingHeadlineLabel: UILabel {
    
    private var attributes = [String: AnyObject]()
    
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
    
    func updateText(text: String?) {
        if let text = text {
            attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
    
    func updateTextWithHeader(header: String?, text: String?) {
        if let header = header, body = text {
            var headerAttributes = attributes
            headerAttributes[NSFontAttributeName] = SnapFonts.gothamRoundedMediumOfSize(font.pointSize)
            
            let updatedText = NSMutableAttributedString(string: header, attributes: headerAttributes)
            updatedText.appendAttributedString(NSAttributedString(string: "\n"))
            updatedText.appendAttributedString(NSAttributedString(string: body, attributes: attributes))
            attributedText = updatedText
        }
    }
    
    private func createDefaultParagraphStyle() -> NSMutableParagraphStyle {
        let defaultParagraphStyle = NSMutableParagraphStyle()
        defaultParagraphStyle.alignment = NSTextAlignment.Center
        return defaultParagraphStyle
    }

}
