import UIKit

class IntroViewController: UIViewController {

    @IBOutlet private var nextButton: UIButton?
    @IBOutlet private var infoLabel: UILabel?
    
    var delegate: IntroViewControllerDelegate?
    private var stringsViewModel: SnapOnboardingStringsViewModel?
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        delegate?.introNextButtonTapped()
    }
    
    func applyStrings(strings: SnapOnboardingStringsViewModel) {
        stringsViewModel = strings
    }
    
    // MARK: - UIViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureLabels()
    }
    
    private func configureLabels() {
        // TODO: Line height
        
        nextButton?.setTitle(stringsViewModel?.next?.uppercaseString, forState: .Normal)
        infoLabel?.text = stringsViewModel?.introHeadline
    }

}
