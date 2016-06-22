import UIKit

class IntroViewController: UIViewController {

    @IBOutlet private var nextButton: UIButton?
    @IBOutlet var headlineLabel: SnapOnboardingHeadlineLabel!
    
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
        
        configureNextButton()
        configureHeadlineLabel()
    }
    
    private func configureNextButton() {
        let title = stringsViewModel?.next?.uppercaseString
        nextButton?.setTitle(title, forState: .Normal)
    }
    
    private func configureHeadlineLabel() {
        headlineLabel?.designableText = stringsViewModel?.introHeadline ?? ""
    }

}
