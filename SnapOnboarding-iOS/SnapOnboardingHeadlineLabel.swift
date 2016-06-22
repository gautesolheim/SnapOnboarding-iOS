//
//  SnapOnboardingHeadlineLabel.swift
//  SnapOnboarding-iOS
//
//  Created by Gaute Solheim on 22.06.2016.
//  Copyright © 2016 Gaute Solheim. All rights reserved.
//

import UIKit

@IBDesignable class SnapOnboardingHeadlineLabel: UILabel {
    
    private var attributes = [String: AnyObject]()
    
    @IBInspectable var designableLineSpacing: CGFloat = 1 {
        didSet {
            let paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle ?? createDefaultParagraphStyle()
            paragraphStyle.lineSpacing = designableLineSpacing
            attributes[NSParagraphStyleAttributeName] = paragraphStyle
            updateText(designableText) // Redundant at runtime, but required for storyboard rendering
        }
    }
    
    @IBInspectable var designableText: String = "Placeholder" {
        didSet {
            updateText(designableText)
        }
    }
    
    private func updateText(newText: String) {
        attributedText = NSMutableAttributedString(string: designableText, attributes: attributes)
    }
    
    private func createDefaultParagraphStyle() -> NSMutableParagraphStyle {
        let defaultParagraphStyle = NSMutableParagraphStyle()
        defaultParagraphStyle.alignment = NSTextAlignment.Center
        return defaultParagraphStyle
    }

}
