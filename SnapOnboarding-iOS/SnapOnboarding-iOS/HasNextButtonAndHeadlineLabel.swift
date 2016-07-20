import UIKit

protocol HasNextButtonAndHeadlineLabel: class {
    
    var nextButton: UIButton? { get }
    var nextButtonAttributes: [String : AnyObject]? { get set }
    
    var headlineLabel: SnapOnboardingHeadlineLabel? { get }
    
    func configureNextButtonAndHeadlineLabelFor3_5Inch()
    func configureNextButtonAndHeadlineLabelFor4_0Inch()
    func configureNextButtonAndHeadlineLabelForIpad()
    func configureNextButtonAndHeadlineLabelForIpadPro()
    
    func setNextButtonTitle(title: String?)
    func createAttributesForNextButton() -> [String : AnyObject]
    
}

extension HasNextButtonAndHeadlineLabel {
    
    func configureNextButtonAndHeadlineLabelFor3_5Inch() {
        nextButton?.contentEdgeInsets.top = 10
    
        headlineLabel?.font = UIFont.gothamRoundedBookOfSize(17)
        headlineLabel?.lineSpacin = 4
    }
    
    func configureNextButtonAndHeadlineLabelFor4_0Inch() {
        headlineLabel?.font = UIFont.gothamRoundedBookOfSize(18)
        headlineLabel?.lineSpacin = 5
    }
    
    func configureNextButtonAndHeadlineLabelFor5_5Inch() {
        headlineLabel?.font = UIFont.gothamRoundedBookOfSize(23)
    }
    
    func configureNextButtonAndHeadlineLabelForIpad() {
        nextButtonAttributes?[NSFontAttributeName] = UIFont.gothamRoundedMediumOfSize(16)
        nextButton?.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 23)
        
        headlineLabel?.font = UIFont.gothamRoundedBookOfSize(26)
    }
    
    func configureNextButtonAndHeadlineLabelForIpadPro() {
        nextButtonAttributes?[NSFontAttributeName] = UIFont.gothamRoundedMediumOfSize(20)
        nextButton?.contentEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 30)
        
        headlineLabel?.font = UIFont.gothamRoundedBookOfSize(34)
        headlineLabel?.lineSpacin = 10
    }
    
    func setNextButtonTitle(title: String?) {
        guard let title = title else {
            return
        }
        
        let attributedText = NSAttributedString(string: title, attributes: nextButtonAttributes)
        UIView.performWithoutAnimation {
            self.nextButton?.setAttributedTitle(attributedText, forState: .Normal)
            self.nextButton?.layoutIfNeeded()
        }
    }
    
    func createAttributesForNextButton() -> [String : AnyObject] {
        var attributes = [String : AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.whiteColor()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.18
        attributes[NSParagraphStyleAttributeName] = paragraphStyle
        
        return attributes
    }
    
}
