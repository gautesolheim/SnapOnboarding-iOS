import UIKit

enum LocationServicesStatus {
    case NotYetRequested
    case WaitingForResponse
    case Enabled
    case Disabled
}

class LocationViewController: UIViewController {
    
    @IBOutlet private var nextButton: UIButton?
    @IBOutlet private var headlineLabel: SnapOnboardingHeadlineLabel?
    @IBOutlet private var enableLocationServicesButton: UIButton?
    @IBOutlet private var notNowButton: UIButton?
    @IBOutlet private var willAskLaterLabel: SnapOnboardingHeadlineLabel?
    
    @IBOutlet private var enableLocationServicesButtonWidth: NSLayoutConstraint?
    
    var delegate: LocationViewControllerDelegate?
    private var viewModel: SnapOnboardingViewModel.LocationViewModel?
    
    private var spinnerImageView = UIImageView()
    private var locationServicesStatus: LocationServicesStatus = .NotYetRequested
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        delegate?.locationNextButtonTapped()
        locationServicesStatus = .WaitingForResponse
        animateEnableLocationServicesButtonToSpinner()
    }
    
    @IBAction func enableLocationServicesButtonTapped(sender: UIButton) {
        delegate?.enableLocationServicesTapped()
        locationServicesStatus = .WaitingForResponse
        animateEnableLocationServicesButtonToSpinner()
    }
    
    @IBAction func notNowButtonTapped(sender: UIButton) {
        configureWillAskLaterLabelForNotNow()
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
    
    private func configureWillAskLaterLabelForNotNow() {
        prepareForWillAskLaterLabelAppearance()
        
        willAskLaterLabel?.updateTextWithHeader(viewModel?.willAskLaterTitle, text: viewModel?.willAskLaterBody)
        
        animateWillAskLaterLabelAppearanceWithDuration(0.1)
    }
    
    private func configureWillAskLaterLabelForLocationDisabled() {
        prepareForWillAskLaterLabelAppearance()
        
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
        animateWillAskLaterLabelAppearanceWithDuration(0.1)
    }
    
    private func configureWillAskLaterLabelForThankYou() {
        prepareForWillAskLaterLabelAppearance()
        
        willAskLaterLabel?.updateTextWithHeader(viewModel?.didEnableLocationServicesTitle, text: viewModel?.didEnableLocationServicesBody)
        
        animateWillAskLaterLabelAppearanceWithDuration(0.1)
    }
    
    private func prepareForWillAskLaterLabelAppearance() {
        willAskLaterLabel?.alpha = 0.0
    }
    
    private func animateWillAskLaterLabelAppearanceWithDuration(duration: Double) {
        willAskLaterLabel?.hidden = false
        
        UIView.animateWithDuration(duration, animations: {
            self.enableLocationServicesButton?.alpha = 0
            self.notNowButton?.alpha = 0
            self.willAskLaterLabel?.alpha = 1
        })
    }
    
    private func animateEnableLocationServicesButtonToSpinner() {
        guard let enableLocationServicesButton = enableLocationServicesButton else {
            return
        }
        
        enableLocationServicesButtonWidth?.active = false
        let backgroundImage = UIImage(named: "btn location clean")! // TODO: swiftgen
        enableLocationServicesButton.setTitle(nil, forState: .Normal)
        enableLocationServicesButton.setBackgroundImage(backgroundImage, forState: .Normal)
        enableLocationServicesButton.contentEdgeInsets = UIEdgeInsetsZero
        
        let spinner = UIImage(named: "icon_m_spinner_black")! // TODO: swiftgen
        spinnerImageView.translatesAutoresizingMaskIntoConstraints = false
        spinnerImageView.image = spinner
        spinnerImageView.alpha = 0.0
        enableLocationServicesButton.addSubview(spinnerImageView)
        enableLocationServicesButton.addConstraint(NSLayoutConstraint(item: spinnerImageView, attribute: .CenterX, relatedBy: .Equal, toItem: enableLocationServicesButton, attribute: .CenterX, multiplier: 1, constant: 0))
        enableLocationServicesButton.addConstraint(NSLayoutConstraint(item: spinnerImageView, attribute: .CenterY, relatedBy: .Equal, toItem: enableLocationServicesButton, attribute: .CenterY, multiplier: 1, constant: 0))
        
        UIView.animateWithDuration(0.3, animations: {
            enableLocationServicesButton.frame.size.width = 0
        }, completion: { _ in
            UIView.animateWithDuration(0.9, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.spinnerImageView.alpha = 1.0
                }, completion: nil)
            self.animateEnableLocationServicesButtonSpinner()
        })
    }
    
    private func animateEnableLocationServicesButtonSpinner() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.spinnerImageView.transform = CGAffineTransformRotate(self.spinnerImageView.transform, CGFloat(M_PI_2))
            }, completion: { _ in
                if self.locationServicesStatus == .WaitingForResponse {
                    self.animateEnableLocationServicesButtonSpinner()
                } else {
                    UIView.animateWithDuration(1.0, delay: 0, options: [UIViewAnimationOptions.CurveEaseOut], animations: {
                        self.spinnerImageView.transform = CGAffineTransformRotate(self.spinnerImageView.transform, CGFloat(M_PI))
                        self.spinnerImageView.alpha = 0
                        self.spinnerImageView.removeFromSuperview()
                        }, completion: nil)
                }
        })
    }

}

extension LocationViewController: LocationViewControllerProtocol {
    
    func configureForViewModel(viewModel: SnapOnboardingViewModel.LocationViewModel) {
        self.viewModel = viewModel
    }
    
    func locationServicesStatusChanged(status: Bool) {
        switch status {
        case true:
            locationServicesStatus = .Enabled
            configureWillAskLaterLabelForThankYou()
        case false:
            locationServicesStatus = .Disabled
            configureWillAskLaterLabelForLocationDisabled()
        }
    }
    
}
