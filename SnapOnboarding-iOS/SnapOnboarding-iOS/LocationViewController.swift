import UIKit
import SnapFonts_iOS

class LocationViewController: UIViewController {
    
    @IBOutlet private(set) var nextButton: UIButton?
    @IBOutlet private(set) var headlineLabel: SnapOnboardingHeadlineLabel?
    @IBOutlet private(set) var enableLocationServicesButton: UIButton?
    @IBOutlet private var notNowButton: UIButton?
    @IBOutlet private var willAskLaterLabel: SnapOnboardingHeadlineLabel?
    @IBOutlet private var tumbleweed: UIImageView?
    @IBOutlet private(set) var sparklingStars: [UIImageView]?
    @IBOutlet private var neighborhoodItems: [UIImageView]?
    @IBOutlet private var neighborhoodView: UIView?
    
    @IBOutlet private var enableLocationServicesButtonWidth: NSLayoutConstraint?
    @IBOutlet private var sparklingViewTopToHeadlineSparklingSpacerBottom: NSLayoutConstraint?
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
    
    // MARK: Gesture recognizers
    
    func willAskLaterLabelWithLocationServicesInstructionsTapped() {
        delegate?.locationServicesInstructionsTapped()
    }

    // MARK: UIViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(viewModel != nil)
        
        setupForScreenSize(SnapOnboardingViewController.screenSize)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNextButton()
        configureHeadlineLabel()
        configureEnableLocationServicesButton()
        configureNotNowButton()
        
        animateSparklingStarsWithCycleDuration(2)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        sparklingStars?.forEach { $0.layer.removeAllAnimations() }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        setupForScreenSize(size)
    }
    
    // MARK: UIView configuration
    
    internal func configureNextButton() {
        nextButton?.setTitle(viewModel?.next?.uppercaseString, forState: .Normal)
    }
    
    internal func configureHeadlineLabel() {
        headlineLabel?.updateText(viewModel?.locationHeadline)
    }
    
    internal func configureEnableLocationServicesButton() {
        enableLocationServicesButton?.setTitle(viewModel?.enableLocationServices?.uppercaseString, forState: .Normal)
        let intrinsicContentWidth = enableLocationServicesButton?.intrinsicContentSize().width ?? 245
        let rightPadding: CGFloat = 26
        let width = intrinsicContentWidth + rightPadding
        enableLocationServicesButtonWidth?.constant = width
    }
    
    internal func configureNotNowButton() {
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
        
        for index in wowYouDeclinedBody.characters.indices {
            if wowYouDeclinedBody[index] == ">" || wowYouDeclinedBody[index] == "›" {
                let int = wowYouDeclinedBody.startIndex.distanceTo(index)
                attributedText.replaceCharactersInRange(NSRange(int ... int), withAttributedString: NSAttributedString(string: String(wowYouDeclinedBody[index]), attributes: [NSForegroundColorAttributeName : angleSignColor]))
            }
        }
        
        willAskLaterLabel?.updateAttributedTextWithHeader(viewModel?.wowYouDeclinedTitle, text: attributedText)
        animateWillAskLaterLabelAppearanceWithDuration(0.2)
        animateSparklingStarsAndNeighborhoodItemsDisappearanceWithDuration(0.2)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(willAskLaterLabelWithLocationServicesInstructionsTapped))
        willAskLaterLabel?.addGestureRecognizer(tapGestureRecognizer)
        willAskLaterLabel?.userInteractionEnabled = true
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
    
    private func animateSparklingStarsAndNeighborhoodItemsDisappearanceWithDuration(duration: Double) {
        guard let sparklingStars = sparklingStars, neighborhoodItems = neighborhoodItems else {
            return
        }
        
        UIView.animateWithDuration(duration, animations: {
            (sparklingStars + neighborhoodItems).forEach {
                $0.alpha = 0.0
            }
        }, completion: { _ in
            self.animateTumbleweedBezierPathTraversalWithDuration(2)
        })
    }
    
    private func animateTumbleweedBezierPathTraversalWithDuration(duration: Double) {
        guard let neighborhoodView = neighborhoodView, tumbleweed = tumbleweed else {
            return
        }
        
        let pathRect = CGRect(x: 0, y: 0, width: neighborhoodView.frame.width, height: neighborhoodView.frame.height)
        
        let startPoint = CGPoint(x: pathRect.width / 10, y: pathRect.height / 1.10)
        
        let point1 = CGPoint(x: startPoint.x + pathRect.width / 6, y: startPoint.y + pathRect.height / 150)
        let control1 = CGPoint(x: point1.x - pathRect.width / 12, y: point1.y - pathRect.height / 20)
        
        let point2 = CGPoint(x: point1.x + pathRect.width / 8, y: point1.y + pathRect.height / 50)
        let control2 = CGPoint(x: point1.x + pathRect.width / 16, y: point1.y - pathRect.height / 30)
        
        let point3 = CGPoint(x: point2.x + pathRect.width / 10, y: point2.y + pathRect.height / 40)
        let control3 = CGPoint(x: point2.x + pathRect.width / 20, y: point2.y - pathRect.height / 40)
        
        let point4 = CGPoint(x: point3.x + pathRect.width / 3, y: point3.y + pathRect.height / 80)
        let control4 = CGPoint(x: point3.x + pathRect.width / 8, y: point3.y - pathRect.height / 80)
        
        let endPoint = point4
        
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        
        path.addQuadCurveToPoint(point1, controlPoint: control1)
        path.addQuadCurveToPoint(point2, controlPoint: control2)
        path.addQuadCurveToPoint(point3, controlPoint: control3)
        path.addQuadCurveToPoint(point4, controlPoint: control4)
        
        let pathShapeLayer = CAShapeLayer()
        pathShapeLayer.path = path.CGPath
        pathShapeLayer.fillColor = nil
        neighborhoodView.layer.addSublayer(pathShapeLayer)
        
        let tumbleweedAnimation = CAKeyframeAnimation(keyPath: "position")
        tumbleweedAnimation.duration = duration
        tumbleweedAnimation.path = pathShapeLayer.path
        tumbleweedAnimation.calculationMode = kCAAnimationPaced
        
        tumbleweed.alpha = 1
        tumbleweed.layer.addAnimation(tumbleweedAnimation, forKey: "position")
        tumbleweed.frame.origin = CGPoint(x: endPoint.x - tumbleweed.frame.width / 2, y: endPoint.y - tumbleweed.frame.height / 2)
        
        animateTumbleweedRotationWithTotalDuration(tumbleweedAnimation.duration, rotations: 10, currentDuration: 0)
    }
    
    private func animateTumbleweedRotationWithTotalDuration(totalDuration: Double, rotations: Int, currentDuration: Double) {
        guard let tumbleweed = tumbleweed else {
            return
        }
        
        let duration = totalDuration / Double(rotations)
        let options: UIViewAnimationOptions = currentDuration == 0 ? .CurveEaseIn : .CurveLinear
        
        UIView.animateWithDuration(duration, delay: 0, options: options, animations: {
            tumbleweed.transform = CGAffineTransformRotate(tumbleweed.transform, CGFloat(M_PI_2))
        }, completion: { _ in
            let currentDuration = currentDuration + duration
            
            if currentDuration > totalDuration - duration {
                UIView.animateWithDuration(0.4, animations: {
                    tumbleweed.alpha = 0
                })
                return
            }
            
            self.animateTumbleweedRotationWithTotalDuration(totalDuration, rotations: rotations, currentDuration: currentDuration)
        })
    }
    
    private func animateEnableLocationServicesButtonToSpinner() {
        guard let enableLocationServicesButton = enableLocationServicesButton else {
            return
        }
        
        enableLocationServicesButtonWidth?.active = false
        let backgroundImage = UIImage(asset: Asset.Btn_Location_Clean)
        
        enableLocationServicesButton.setTitle(nil, forState: .Normal)
        enableLocationServicesButton.setBackgroundImage(backgroundImage, forState: .Normal)
        enableLocationServicesButton.contentEdgeInsets = UIEdgeInsetsZero
        
        let spinner = UIImage(asset: Asset.Icon_m_spinner_black)
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
    
    func locationServicesStatusChanged(status: LocationServicesStatus) {
        assert(status == .Enabled || status == .Disabled)
        
        if status == .Enabled {
            locationServicesStatus = .Enabled
            configureWillAskLaterLabelForThankYou()
        } else {
            locationServicesStatus = .Disabled
            configureWillAskLaterLabelForLocationDisabled()
        }
    }
    
}

// MARK: - HasSparklingStars

extension LocationViewController: HasSparklingStars {}

// MARK: - HasNextButtonAndHeadlineLabel

extension LocationViewController: HasNextButtonAndHeadlineLabel {}

// MARK: - ScreenSizesProtocol

extension LocationViewController {
    
    func setupFor3_5InchPortrait() {
        configureNextButtonAndHeadlineLabelFor3_5Inch()
        willAskLaterLabel?.font = SnapFonts.gothamRoundedBookOfSize(14)

        sparklingViewToSuperViewHeightRelation?.constant = -30
        notNowButtonBottomToSuperViewBottom?.constant = 0
        willAskLaterLabelBottomToSuperViewBottom?.constant = 16
    }
    
    func setupFor4_0InchPortrait() {
        configureNextButtonAndHeadlineLabelFor4_0Inch()
        willAskLaterLabel?.font = SnapFonts.gothamRoundedBookOfSize(14)
        
        sparklingViewToSuperViewHeightRelation?.constant = -20
    }
    
    func setupFor5_5InchPortrait() {
        configureNextButtonAndHeadlineLabelFor5_5Inch()
    }
    
    func setupForIpadPortrait(size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpad()
        
        sparklingViewToSuperViewHeightRelation?.constant = -20
        
        if size.width <= 320 {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 90
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 70
        }
    }
    
    func setupForIpadLandscape(size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpad()
        
        sparklingViewToSuperViewHeightRelation?.constant = 20
        
        if size.width <= 320 {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = -10
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 20
        }
    }
    
    func setupForIpadProPortrait(size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpadPro()
        
        sparklingViewToSuperViewHeightRelation?.constant = -30
        
        if size.width <= 375 {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 160
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 90
        }
    }
    
    func setupForIpadProLandscape(size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpadPro()
        
        sparklingViewToSuperViewHeightRelation?.constant = 20
        
        if size.width <= 375 {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 55
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 20
        }
    }

}

