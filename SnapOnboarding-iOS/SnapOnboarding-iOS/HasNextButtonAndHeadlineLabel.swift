import UIKit
import SnapFonts_iOS

protocol HasNextButtonAndHeadlineLabel: class {
    
    var nextButton: UIButton? { get }
    var headlineLabel: SnapOnboardingHeadlineLabel? { get }
    
    func configureNextButtonAndHeadlineLabelFor3_5Inch()
    func configureNextButtonAndHeadlineLabelFor4_0Inch()
    func configureNextButtonAndHeadlineLabelForIpad()
    func configureNextButtonAndHeadlineLabelForIpadPro()
    
}

extension HasNextButtonAndHeadlineLabel {
    
    func configureNextButtonAndHeadlineLabelFor3_5Inch() {
        nextButton?.contentEdgeInsets.top = 10
    
        headlineLabel?.font = SnapFonts.gothamRoundedBook(ofSize: 17)
        headlineLabel?.lineSpacin = 4
    }

    func configureNextButtonAndHeadlineLabelFor4_0Inch() {
        headlineLabel?.font = SnapFonts.gothamRoundedBook(ofSize: 18)
        headlineLabel?.lineSpacin = 5
    }
    
    func configureNextButtonAndHeadlineLabelFor5_5Inch() {
        headlineLabel?.font = SnapFonts.gothamRoundedBook(ofSize: 23)
    }
    
    func configureNextButtonAndHeadlineLabelForIpad() {
        nextButton?.titleLabel?.font = SnapFonts.gothamRoundedMedium(ofSize: 16)
        nextButton?.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 23)
        
        headlineLabel?.font = SnapFonts.gothamRoundedBook(ofSize: 26)
    }
    
    func configureNextButtonAndHeadlineLabelForIpadPro() {
        nextButton?.titleLabel?.font = SnapFonts.gothamRoundedMedium(ofSize: 20)
        nextButton?.contentEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 30)
        
        headlineLabel?.font = SnapFonts.gothamRoundedBook(ofSize: 34)
        headlineLabel?.lineSpacin = 10
    }
    
}
