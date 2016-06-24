import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet private var nextButton: UIButton?
    @IBOutlet private var headlineLabel: SnapOnboardingHeadlineLabel?
    @IBOutlet private var enableLocationServicesButton: UIButton?
    @IBOutlet private var notNowButton: SnapOnboardingUnderlinedButton?
    
    @IBOutlet var enableLocationServicesButtonWidth: NSLayoutConstraint?
    
    var delegate: LocationViewControllerDelegate?
    private var stringsViewModel: SnapOnboardingStringsViewModel?
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        delegate?.locationNextButtonTapped()
    }
    
    @IBAction func enableLocationServicesButtonTapped(sender: UIButton) {
        delegate?.enableLocationServicesTapped()
    }
    
    @IBAction func notNowButtonTapped(sender: UIButton) {
        // TODO: Display will ask later label
    }
    
    func applyStrings(strings: SnapOnboardingStringsViewModel) {
        self.stringsViewModel = strings
    }

    // MARK: - UIViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNextButton()
        configureHeadlineLabel()
        configureEnableLocationServicesButton()
        configureNotNowButton()
    }
    
    private func configureNextButton() {
        let title = stringsViewModel?.next?.uppercaseString
        nextButton?.setTitle(title, forState: .Normal)
    }
    
    private func configureHeadlineLabel() {
        headlineLabel?.updateText(stringsViewModel?.locationHeadline)
    }
    
    private func configureEnableLocationServicesButton() {
        enableLocationServicesButton?.setTitle(stringsViewModel?.enableLocationServices?.uppercaseString, forState: .Normal)
        let intrinsicContentWidth = enableLocationServicesButton?.intrinsicContentSize().width ?? 245
        let requiredWidth = intrinsicContentWidth + 26
        enableLocationServicesButtonWidth?.constant = requiredWidth
    }
    
    private func configureNotNowButton() {
        notNowButton?.updateText(stringsViewModel?.notNow)
    }

}
