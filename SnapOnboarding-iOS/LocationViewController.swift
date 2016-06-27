import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet private var nextButton: UIButton?
    @IBOutlet private var headlineLabel: SnapOnboardingHeadlineLabel?
    @IBOutlet private var enableLocationServicesButton: UIButton?
    @IBOutlet private var notNowButton: UIButton?
    @IBOutlet private var willAskLaterLabel: SnapOnboardingHeadlineLabel?
    
    @IBOutlet var enableLocationServicesButtonWidth: NSLayoutConstraint?
    
    var delegate: LocationViewControllerDelegate?
    private var viewModel: SnapOnboardingViewModel.LocationViewModel?
    
    private var spinnerImageView = UIImageView()
    private var shouldAnimateSpinner = true
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        delegate?.locationNextButtonTapped()
    }
    
    @IBAction func enableLocationServicesButtonTapped(sender: UIButton) {
        delegate?.enableLocationServicesTapped()
        animateEnableLocationServicesButtonToSpinner()
    }
    
    @IBAction func notNowButtonTapped(sender: UIButton) {
        //configureWillAskLaterLabelForNotNow()
        
        // Reset for testing
        if shouldAnimateSpinner {
            shouldAnimateSpinner = false
        } else {
            shouldAnimateSpinner = true
            enableLocationServicesButton?.setBackgroundImage(UIImage(named: "btn location"), forState: .Normal)
            enableLocationServicesButtonWidth?.active = true
            spinnerImageView.removeFromSuperview()
            configureEnableLocationServicesButton()
        }
    }
    
    func configureForViewModel(viewModel: SnapOnboardingViewModel.LocationViewModel) {
        self.viewModel = viewModel
    }

    // MARK: UIViewController life cycle
    
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
        let title = viewModel?.next?.uppercaseString
        nextButton?.setTitle(title, forState: .Normal)
    }
    
    private func configureHeadlineLabel() {
        headlineLabel?.updateText(viewModel?.locationHeadline)
    }
    
    private func configureEnableLocationServicesButton() {
        enableLocationServicesButton?.setTitle(viewModel?.enableLocationServices?.uppercaseString, forState: .Normal)
        let intrinsicContentWidth = enableLocationServicesButton?.intrinsicContentSize().width ?? 245
        let rightPadding: CGFloat = 26
        let width = intrinsicContentWidth + rightPadding
        enableLocationServicesButtonWidth?.constant = width
    }
    
    private func configureNotNowButton() {
        notNowButton?.setTitle(viewModel?.notNow, forState: .Normal)
    }
    
    private func prepareForWillAskLaterLabel() {
        enableLocationServicesButton?.hidden = true
        notNowButton?.hidden = true
    }
    
    private func configureWillAskLaterLabelForNotNow() {
        prepareForWillAskLaterLabel()
        willAskLaterLabel?.updateTextWithHeader(viewModel?.willAskLaterTitle, text: viewModel?.willAskLaterBody)
        willAskLaterLabel?.hidden = false
    }
    
    private func configureWillAskLaterLabelForLocationDisabled() {
        prepareForWillAskLaterLabel()
        
        guard let wowYouDeclinedBody = viewModel?.wowYouDeclinedBody else {
            return
        }
        
        let attributedText = NSMutableAttributedString(string: wowYouDeclinedBody)
        let angleSignColor = UIColor(red: 254/255.0, green: 232/255.0, blue: 5/255.0, alpha: 1.0)
        
        for index in viewModel!.wowYouDeclinedBody!.characters.indices {
            if wowYouDeclinedBody[index] == ">" || wowYouDeclinedBody[index] == "›" {
                let int = wowYouDeclinedBody.startIndex.distanceTo(index)
                attributedText.replaceCharactersInRange(NSRange(int ... int), withAttributedString: NSAttributedString(string: String(wowYouDeclinedBody[index]), attributes: [NSForegroundColorAttributeName : angleSignColor]))
            }
        }
        
        willAskLaterLabel?.updateAttributedTextWithHeader(viewModel?.wowYouDeclinedTitle, text: attributedText)
        willAskLaterLabel?.hidden = false
    }
    
    private func animateEnableLocationServicesButtonToSpinner() {
        enableLocationServicesButtonWidth?.active = false
        let backgroundImage = UIImage(named: "btn location clean")! // TODO: swiftgen
        enableLocationServicesButton?.setTitle(nil, forState: .Normal)
        enableLocationServicesButton?.setBackgroundImage(backgroundImage, forState: .Normal)
        
        let spinner = UIImage(named: "icon_m_spinner_black")! // TODO: swiftgen
        spinnerImageView.image = spinner
        spinnerImageView.translatesAutoresizingMaskIntoConstraints = false
        spinnerImageView.alpha = 0.0
        enableLocationServicesButton?.addSubview(spinnerImageView)
        enableLocationServicesButton?.addConstraint(NSLayoutConstraint(item: enableLocationServicesButton!, attribute: .CenterX, relatedBy: .Equal, toItem: spinnerImageView, attribute: .CenterX, multiplier: 1, constant: 0))
        enableLocationServicesButton?.addConstraint(NSLayoutConstraint(item: enableLocationServicesButton!, attribute: .CenterY, relatedBy: .Equal, toItem: spinnerImageView, attribute: .CenterY, multiplier: 1, constant: 1))
        
        UIView.animateWithDuration(0.3, animations: {
            self.enableLocationServicesButton?.frame.size.width = 0
        }, completion: { _ in
            UIView.animateWithDuration(1.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.spinnerImageView.alpha = 1.0
                }, completion: nil)
            self.animateEnableLocationServicesButtonSpinner()
        })
    }
    
    private func animateEnableLocationServicesButtonSpinner() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.spinnerImageView.transform = CGAffineTransformRotate(self.spinnerImageView.transform, CGFloat(M_PI_2))
            }, completion: { _ in
                if self.shouldAnimateSpinner {
                    self.animateEnableLocationServicesButtonSpinner()
                } else {
                    UIView.animateWithDuration(0.5, delay: 0, options: [UIViewAnimationOptions.CurveEaseOut], animations: {
                        self.spinnerImageView.transform = CGAffineTransformRotate(self.spinnerImageView.transform, CGFloat(M_PI_2))
                        }, completion: nil)
                }
        })
    }

}
