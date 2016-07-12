import UIKit
import SnapFonts_iOS

protocol HasNextButtonAndHeadlineLabel: class {
    
    var nextButton: UIButton? { get }
    var headlineLabel: SnapOnboardingHeadlineLabel? { get }
    
    func configureNextButtonAndHeadlineLabelFor3_5Inch()
    func configureNextButtonAndHeadlineLabelFor4_0Inch()
    func configureNextButtonAndHeadlineLabelForIpad()
    
}

extension HasNextButtonAndHeadlineLabel {
    
    func configureNextButtonAndHeadlineLabelFor3_5Inch() {
        nextButton?.contentEdgeInsets.top = 10
    
        headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(17)
        headlineLabel?.lineSpacin = 4
    }
    
    func configureNextButtonAndHeadlineLabelFor4_0Inch() {
        headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(18)
        headlineLabel?.lineSpacin = 5
    }
    
    func configureNextButtonAndHeadlineLabelForIpad() {
        nextButton?.titleLabel?.font = SnapFonts.gothamRoundedMediumOfSize(16)
        nextButton?.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 23)
        
        headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(26)
    }
    
}
