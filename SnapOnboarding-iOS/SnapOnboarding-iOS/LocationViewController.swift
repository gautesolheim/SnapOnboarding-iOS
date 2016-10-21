import UIKit
import SnapFonts_iOS

class LocationViewController: UIViewController {
    
    @IBOutlet fileprivate(set) var nextButton: UIButton?
    @IBOutlet fileprivate(set) var headlineLabel: SnapOnboardingHeadlineLabel?
    @IBOutlet fileprivate(set) var enableLocationServicesButton: UIButton?
    @IBOutlet fileprivate var notNowButton: UIButton?
    @IBOutlet fileprivate var willAskLaterLabel: SnapOnboardingHeadlineLabel?
    @IBOutlet fileprivate var tumbleweed: UIImageView?
    @IBOutlet fileprivate(set) var sparklingStars: [UIImageView]?
    @IBOutlet fileprivate var neighborhoodItems: [UIImageView]?
    @IBOutlet fileprivate var neighborhoodView: UIView?
    
    @IBOutlet fileprivate var enableLocationServicesButtonWidth: NSLayoutConstraint?
    @IBOutlet fileprivate var sparklingViewTopToHeadlineSparklingSpacerBottom: NSLayoutConstraint?
    @IBOutlet fileprivate var sparklingViewToSuperViewHeightRelation: NSLayoutConstraint?
    @IBOutlet fileprivate var notNowButtonBottomToSuperViewBottom: NSLayoutConstraint?
    @IBOutlet fileprivate var willAskLaterLabelBottomToSuperViewBottom: NSLayoutConstraint?
    
    var delegate: LocationViewControllerDelegate?
    fileprivate var viewModel: SnapOnboardingViewModel.LocationViewModel?
    
    fileprivate var spinnerImageView = UIImageView()
    fileprivate var locationServicesStatus: LocationServicesStatus = .notYetRequested
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        delegate?.locationNextButtonTapped()
    }
    
    @IBAction func enableLocationServicesButtonTapped(_ sender: UIButton) {
        delegate?.enableLocationServicesTapped()
        locationServicesStatus = .waitingForResponse
        animateEnableLocationServicesButtonToSpinner()
    }
    
    @IBAction func notNowButtonTapped(_ sender: UIButton) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNextButton()
        configureHeadlineLabel()
        configureEnableLocationServicesButton()
        configureNotNowButton()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        setupForScreenSize(size)
    }
    
    // MARK: UIView configuration
    
    internal func configureNextButton() {
        nextButton?.setTitle(viewModel?.next?.uppercased(), for: UIControlState())
    }
    
    internal func configureHeadlineLabel() {
        headlineLabel?.updateText(viewModel?.locationHeadline)
    }
    
    internal func configureEnableLocationServicesButton() {
        enableLocationServicesButton?.setTitle(viewModel?.enableLocationServices?.uppercased(), for: UIControlState())
        let intrinsicContentWidth = enableLocationServicesButton?.intrinsicContentSize.width ?? 245
        let rightPadding: CGFloat = 26
        let width = intrinsicContentWidth + rightPadding
        enableLocationServicesButtonWidth?.constant = width
    }
    
    internal func configureNotNowButton() {
        notNowButton?.setTitle(viewModel?.notNow, for: UIControlState())
    }
    
    fileprivate func configureWillAskLaterLabelForThankYou() {
        willAskLaterLabel?.updateTextWithHeader(viewModel?.didEnableLocationServicesTitle, text: viewModel?.didEnableLocationServicesBody)
        animateWillAskLaterLabelAppearanceWithDuration(0.1)
    }
    
    fileprivate func configureWillAskLaterLabelForLocationDisabled() {
        guard let wowYouDeclinedBody = viewModel?.wowYouDeclinedBody else {
            return
        }
        
        // Color arrows yellow
        let attributedText = NSMutableAttributedString(string: wowYouDeclinedBody)
        let angleSignColor = UIColor(red: 254/255.0, green: 232/255.0, blue: 5/255.0, alpha: 1.0)
        
        for index in wowYouDeclinedBody.characters.indices {
            if wowYouDeclinedBody[index] == ">" || wowYouDeclinedBody[index] == "›" {
                let int = wowYouDeclinedBody.characters.distance(from: wowYouDeclinedBody.startIndex, to: index)
                attributedText.replaceCharacters(in: NSRange(int ..< (int+1)), with: NSAttributedString(string: String(wowYouDeclinedBody[index]), attributes: [NSForegroundColorAttributeName : angleSignColor]))
            }
        }
        
        willAskLaterLabel?.updateAttributedTextWithHeader(viewModel?.wowYouDeclinedTitle, text: attributedText)
        animateWillAskLaterLabelAppearanceWithDuration(0.2)
        animateSparklingStarsAndNeighborhoodItemsDisappearanceWithDuration(0.2)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(willAskLaterLabelWithLocationServicesInstructionsTapped))
        willAskLaterLabel?.addGestureRecognizer(tapGestureRecognizer)
        willAskLaterLabel?.isUserInteractionEnabled = true
    }
    
    fileprivate func configureWillAskLaterLabelForNotNow() {
        willAskLaterLabel?.updateTextWithHeader(viewModel?.willAskLaterTitle, text: viewModel?.willAskLaterBody)
        animateWillAskLaterLabelAppearanceWithDuration(0.1)
    }
    
    // MARK: UIView animation
    
    fileprivate func animateWillAskLaterLabelAppearanceWithDuration(_ duration: Double) {
        willAskLaterLabel?.alpha = 0
        willAskLaterLabel?.isHidden = false
        
        UIView.animate(withDuration: duration, animations: {
            self.enableLocationServicesButton?.alpha = 0
            self.notNowButton?.alpha = 0
            self.willAskLaterLabel?.alpha = 1
        })
    }
    
    fileprivate func animateSparklingStarsAndNeighborhoodItemsDisappearanceWithDuration(_ duration: Double) {
        guard let sparklingStars = sparklingStars, let neighborhoodItems = neighborhoodItems else {
            return
        }
        
        UIView.animate(withDuration: duration, animations: {
            (sparklingStars + neighborhoodItems).forEach {
                $0.alpha = 0.0
            }
        }, completion: { [weak self] _ in
            self?.animateTumbleweedBezierPathTraversalWithDuration(2)
        })
    }
    
    fileprivate func animateTumbleweedBezierPathTraversalWithDuration(_ duration: Double) {
        guard let neighborhoodView = neighborhoodView, let tumbleweed = tumbleweed else {
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
        path.move(to: startPoint)
        
        path.addQuadCurve(to: point1, controlPoint: control1)
        path.addQuadCurve(to: point2, controlPoint: control2)
        path.addQuadCurve(to: point3, controlPoint: control3)
        path.addQuadCurve(to: point4, controlPoint: control4)
        
        let pathShapeLayer = CAShapeLayer()
        pathShapeLayer.path = path.cgPath
        pathShapeLayer.fillColor = nil
        neighborhoodView.layer.addSublayer(pathShapeLayer)
        
        let tumbleweedAnimation = CAKeyframeAnimation(keyPath: "position")
        tumbleweedAnimation.duration = duration
        tumbleweedAnimation.path = pathShapeLayer.path
        tumbleweedAnimation.calculationMode = kCAAnimationPaced
        
        tumbleweed.alpha = 1
        tumbleweed.layer.add(tumbleweedAnimation, forKey: "position")
        tumbleweed.frame.origin = CGPoint(x: endPoint.x - tumbleweed.frame.width / 2, y: endPoint.y - tumbleweed.frame.height / 2)
        
        animateTumbleweedRotationWithTotalDuration(tumbleweedAnimation.duration, rotations: 10, currentDuration: 0)
    }
    
    fileprivate func animateTumbleweedRotationWithTotalDuration(_ totalDuration: Double, rotations: Int, currentDuration: Double) {
        let duration = totalDuration / Double(rotations)
        let options: UIViewAnimationOptions = currentDuration == 0 ? .curveEaseIn : .curveLinear
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: { [weak self] in
            guard let transform = self?.tumbleweed?.transform else { return }
            self?.tumbleweed?.transform = transform.rotated(by: CGFloat(M_PI_2))
        }, completion: { [weak self] _ in
            let currentDuration = currentDuration + duration
            
            if currentDuration > totalDuration - duration {
                UIView.animate(withDuration: 0.4, animations: {
                    self?.tumbleweed?.alpha = 0
                })
                return
            }
            
            self?.animateTumbleweedRotationWithTotalDuration(totalDuration, rotations: rotations, currentDuration: currentDuration)
        })
    }
    
    fileprivate func animateEnableLocationServicesButtonToSpinner() {
        guard let enableLocationServicesButton = enableLocationServicesButton else {
            return
        }
        
        enableLocationServicesButton.setTitle(nil, for: UIControlState())
        enableLocationServicesButton.setBackgroundImage(Asset.Btn_White_Clean.image, for: UIControlState())
        enableLocationServicesButton.contentEdgeInsets = UIEdgeInsets.zero

        spinnerImageView.translatesAutoresizingMaskIntoConstraints = false
        spinnerImageView.image = Asset.Icon_m_spinner_black.image
        spinnerImageView.alpha = 0.0
        enableLocationServicesButton.addSubview(spinnerImageView)
        enableLocationServicesButton.addConstraint(NSLayoutConstraint(item: spinnerImageView, attribute: .centerX, relatedBy: .equal, toItem: enableLocationServicesButton, attribute: .centerX, multiplier: 1, constant: 0))
        enableLocationServicesButton.addConstraint(NSLayoutConstraint(item: spinnerImageView, attribute: .centerY, relatedBy: .equal, toItem: enableLocationServicesButton, attribute: .centerY, multiplier: 1, constant: -1))
        
        enableLocationServicesButtonWidth?.constant = enableLocationServicesButton.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            enableLocationServicesButton.layoutIfNeeded()
        }, completion: { [weak self] _ in
            UIView.animate(withDuration: 0.9, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self?.spinnerImageView.alpha = 1.0
                }, completion: nil)
            self?.animateEnableLocationServicesButtonSpinner()
        })
    }
    
    fileprivate func animateEnableLocationServicesButtonSpinner() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: { [weak self] in
            guard let transform = self?.spinnerImageView.transform else { return }
            self?.spinnerImageView.transform = transform.rotated(by: CGFloat(M_PI_2))
            }, completion: { [weak self] _ in
                if self?.locationServicesStatus == .waitingForResponse {
                    self?.animateEnableLocationServicesButtonSpinner()
                } else {
                    UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                        guard let transform = self?.spinnerImageView.transform else { return }
                        self?.spinnerImageView.transform = transform.rotated(by: CGFloat(M_PI))
                        self?.spinnerImageView.alpha = 0
                        }, completion: { _ in
                            self?.spinnerImageView.removeFromSuperview()
                        })
                }
        })
    }

}

// MARK: - LocationViewControllerProtocol

extension LocationViewController: LocationViewControllerProtocol {
    
    func configureForViewModel(_ viewModel: SnapOnboardingViewModel.LocationViewModel) {
        self.viewModel = viewModel
    }
    
    func locationServicesStatusChanged(_ status: LocationServicesStatus) {
        assert(status == .enabled || status == .disabled)
        
        if status == .enabled {
            locationServicesStatus = .enabled
            configureWillAskLaterLabelForThankYou()
        } else {
            locationServicesStatus = .disabled
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
    
    func setupForIpadPortrait(_ size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpad()
        
        sparklingViewToSuperViewHeightRelation?.constant = -20
        
        if size.width <= 320 {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 90
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 70
        }
    }
    
    func setupForIpadLandscape(_ size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpad()
        
        sparklingViewToSuperViewHeightRelation?.constant = 20
        
        if size.width <= 320 {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = -10
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 20
        }
    }
    
    func setupForIpadProPortrait(_ size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpadPro()
        
        sparklingViewToSuperViewHeightRelation?.constant = -30
        
        if size.width <= 375 {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 160
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 90
        }
    }
    
    func setupForIpadProLandscape(_ size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpadPro()
        
        sparklingViewToSuperViewHeightRelation?.constant = 20
        
        if size.width <= 375 {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 55
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 20
        }
    }

}

