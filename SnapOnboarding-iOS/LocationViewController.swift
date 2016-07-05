import UIKit
import SnapFonts_iOS

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
    @IBOutlet private(set) var sparklingStars: [UIImageView]?
    
    @IBOutlet private var enableLocationServicesButtonWidth: NSLayoutConstraint?
    @IBOutlet private var sparklingViewToSuperViewHeightRelation: NSLayoutConstraint?
    @IBOutlet private var notNowButtonBottomToSuperViewBottom: NSLayoutConstraint?
    @IBOutlet private var willAskLaterLabelBottomToSuperViewBottom: NSLayoutConstraint?
    
    var delegate: LocationViewControllerDelegate?
    private var viewModel: SnapOnboardingViewModel.LocationViewModel?
    
    private var spinnerImageView = UIImageView()
    private var locationServicesStatus: LocationServicesStatus = .NotYetRequested
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        delegate?.locationNextButtonTapped()
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
        
        assert(viewModel != nil)
        
        setupForScreenSize(UIScreen.mainScreen().bounds)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNextButton()
        configureHeadlineLabel()
        configureEnableLocationServicesButton()
        configureNotNowButton()
        
        let duration: NSTimeInterval = 2
        animateSparklingStarsWithCycleDuration(duration)
    }
    
    // MARK: UIView configuration
    
    private func configureNextButton() {
        nextButton?.setTitle(viewModel?.next?.uppercaseString, forState: .Normal)
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
    
    private func configureWillAskLaterLabelForThankYou() {
        willAskLaterLabel?.updateTextWithHeader(viewModel?.didEnableLocationServicesTitle, text: viewModel?.didEnableLocationServicesBody)
        animateWillAskLaterLabelAppearanceWithDuration(0.1)
    }
    
    private func configureWillAskLaterLabelForLocationDisabled() {
        guard let wowYouDeclinedBody = viewModel?.wowYouDeclinedBody else {
            return
        }
        
        // Color arrows yellow
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
    
    private func configureWillAskLaterLabelForNotNow() {
        willAskLaterLabel?.updateTextWithHeader(viewModel?.willAskLaterTitle, text: viewModel?.willAskLaterBody)
        animateWillAskLaterLabelAppearanceWithDuration(0.1)
    }
    
    // MARK: UIView animation
    
    private func animateWillAskLaterLabelAppearanceWithDuration(duration: Double) {
        willAskLaterLabel?.alpha = 0
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
        enableLocationServicesButton.addConstraint(NSLayoutConstraint(item: spinnerImageView, attribute: .CenterY, relatedBy: .Equal, toItem: enableLocationServicesButton, attribute: .CenterY, multiplier: 1, constant: -1))
        
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

// MARK: - LocationViewControllerProtocol

extension LocationViewController: LocationViewControllerProtocol {
    
    func configureForViewModel(viewModel: SnapOnboardingViewModel.LocationViewModel) {
        self.viewModel = viewModel
    }
    
    func locationServicesStatusChanged(status: Bool) {
        if status {
            locationServicesStatus = .Enabled
            configureWillAskLaterLabelForThankYou()
        } else {
            locationServicesStatus = .Disabled
            configureWillAskLaterLabelForLocationDisabled()
        }
    }
    
}

// MARK: - HasSparklingStars

extension LocationViewController: HasSparklingStars {
    
}

// MARK: - ScreenSizesProtocol

extension LocationViewController {
    
    func setupFor3_5Inch() {
        nextButton?.contentEdgeInsets.top -= 5
        
        headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(17)
        headlineLabel?.lineSpacin = 4
        
        willAskLaterLabel?.font = SnapFonts.gothamRoundedBookOfSize(14)
        
        sparklingViewToSuperViewHeightRelation?.constant -= 30
        notNowButtonBottomToSuperViewBottom?.constant -= 17
        willAskLaterLabelBottomToSuperViewBottom?.constant -= 10
    }
    
    func setupFor4_0Inch() {
        headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(18)
        headlineLabel?.lineSpacin = 5
        
        willAskLaterLabel?.font = SnapFonts.gothamRoundedBookOfSize(14)
        
        sparklingViewToSuperViewHeightRelation?.constant -= 20
    }

}

