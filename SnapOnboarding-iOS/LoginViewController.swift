import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var continueWithFacebookButton: UIButton?
    @IBOutlet var continueWithInstagramButton: UIButton?
    @IBOutlet var skipLoginButton: UIButton?
    
    @IBAction func continueWithFacebookButtonTapped(sender: UIButton) {
        delegate?.facebookSignupTapped()
    }
    
    @IBAction func continueWithInstagramButtonTapped(sender: UIButton) {
        delegate?.instagramSignupTapped()
    }
    
    @IBAction func skipLoginButtonTapped(sender: UIButton) {
        delegate?.skipLoginButtonTapped()
    }
    
    var delegate: LoginViewControllerDelegate?
    private var stringsViewModel: SnapOnboardingStringsViewModel?
    
    func applyStrings(strings: SnapOnboardingStringsViewModel) {
        self.stringsViewModel = strings
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
        
        
    }

}
