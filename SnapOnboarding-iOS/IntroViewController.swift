import UIKit

protocol IntroViewControllerProtocol: class {
//    var delegate: IntroViewControllerDelegate? { get set }
//    func configureForViewModel(viewModel: IntroViewModel)
}

class IntroViewController: UIViewController {

    @IBOutlet private var nextButton: UIButton?
    @IBOutlet private var headlineLabel: SnapOnboardingHeadlineLabel?
    
    var delegate: IntroViewControllerDelegate?
    private var stringsViewModel: SnapOnboardingViewModel?
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        delegate?.introNextButtonTapped()
    }
    
    func applyStrings(strings: SnapOnboardingViewModel) {
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
        headlineLabel?.updateText(stringsViewModel?.introHeadline)
    }

}

extension IntroViewController: IntroViewControllerProtocol {
    
}