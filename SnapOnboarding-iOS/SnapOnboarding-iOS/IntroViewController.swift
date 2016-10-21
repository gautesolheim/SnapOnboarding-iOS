import UIKit
import SnapFonts_iOS

private enum EmbedSegueIdentifier: String {
    case TagsCollectionViewController = "TagsContainerViewEmbed"
}

class IntroViewController: UIViewController {

    @IBOutlet fileprivate(set) var nextButton: UIButton?
    @IBOutlet fileprivate(set) var headlineLabel: SnapOnboardingHeadlineLabel?
    @IBOutlet fileprivate(set) var sparklingStars: [UIImageView]?
    
    @IBOutlet fileprivate var topSpacerToSuperViewHeightRelation: NSLayoutConstraint?
    @IBOutlet fileprivate var sparklingViewTopToHeadlineSparklingSpacerBottom: NSLayoutConstraint?
    @IBOutlet fileprivate var tagsContainerViewHeight: NSLayoutConstraint?
    @IBOutlet fileprivate var tagsContainerViewTopToPhoneViewBottom: NSLayoutConstraint?
    @IBOutlet fileprivate var phoneViewTopToSparklingViewTop: NSLayoutConstraint?
    @IBOutlet fileprivate var phoneViewToSparklingViewHeightRelation: NSLayoutConstraint?
    @IBOutlet fileprivate var sparklingViewToSuperViewHeightRelation: NSLayoutConstraint?
    
    var delegate: IntroViewControllerDelegate?
    fileprivate var viewModel: SnapOnboardingViewModel.IntroViewModel?
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        delegate?.introNextButtonTapped()
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
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        setupForScreenSize(size)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let viewModel = viewModel else {
            return
        }
        
        switch identifier {
        case EmbedSegueIdentifier.TagsCollectionViewController.rawValue:
            let destinationViewController = segue.destination as? TagsCollectionViewController
            let viewModel = TagsViewModel(data: viewModel.tags)
            destinationViewController?.configureForViewModel(viewModel)
        default: break
        }
    }
    
    // MARK: UIView configuration
    
    internal func configureNextButton() {
        let title = viewModel?.next?.uppercased()
        UIView.performWithoutAnimation {
            self.nextButton?.setTitle(title, for: UIControlState())
            self.nextButton?.layoutIfNeeded()
        }
    }
    
    internal func configureHeadlineLabel() {
        headlineLabel?.updateText(viewModel?.introHeadline)
    }

}

// MARK: - IntroViewControllerProtocol

extension IntroViewController: IntroViewControllerProtocol {
    
    func configureForViewModel(_ viewModel: SnapOnboardingViewModel.IntroViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - HasSparklingStars

extension IntroViewController: HasSparklingStars {}

// MARK: - HasNextButtonAndHeadlineLabel

extension IntroViewController: HasNextButtonAndHeadlineLabel {}

// MARK: - ScreenSizesProtocol

extension IntroViewController {
    
    func setupFor3_5InchPortrait() {
        configureNextButtonAndHeadlineLabelFor3_5Inch()
        
        tagsContainerViewHeight?.constant = 30
        sparklingViewToSuperViewHeightRelation?.constant = -10
    }
    
    func setupFor4_0InchPortrait() {
        configureNextButtonAndHeadlineLabelFor4_0Inch()
        
        sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = -10
        sparklingViewToSuperViewHeightRelation?.constant = 10
        phoneViewToSparklingViewHeightRelation?.constant = -5
    }
    
    func setupFor5_5InchPortrait() {
        configureNextButtonAndHeadlineLabelFor5_5Inch()
    }
    
    func setupForIpadPortrait(_ size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpad()
        
        phoneViewTopToSparklingViewTop?.constant = 40
        phoneViewToSparklingViewHeightRelation?.constant = 20
        tagsContainerViewHeight?.constant = 80
        
        if size.width <= 320 {
            sparklingViewToSuperViewHeightRelation?.constant = -120
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 20
        } else {
            sparklingViewToSuperViewHeightRelation?.constant = -20
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 30
        }
    }
    
    func setupForIpadLandscape(_ size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpad()
        
        phoneViewTopToSparklingViewTop?.constant = 20
        tagsContainerViewHeight?.constant = 80
        
        if size.width <= 320 {
            sparklingViewToSuperViewHeightRelation?.constant = -110
            phoneViewToSparklingViewHeightRelation?.constant = -20
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 10
            sparklingViewToSuperViewHeightRelation?.constant = 20
            phoneViewToSparklingViewHeightRelation?.constant = 20
        }
    }
    
    func setupForIpadProPortrait(_ size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpadPro()
        
        phoneViewTopToSparklingViewTop?.constant = 50
        tagsContainerViewHeight?.constant = 90
        
        if size.width <= 375 {
            topSpacerToSuperViewHeightRelation?.constant = 20
            sparklingViewToSuperViewHeightRelation?.constant = -260
            phoneViewToSparklingViewHeightRelation?.constant = -20
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 40
            sparklingViewToSuperViewHeightRelation?.constant = -100
            phoneViewToSparklingViewHeightRelation?.constant = 30
        }
    }
    
    func setupForIpadProLandscape(_ size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpadPro()
        
        phoneViewTopToSparklingViewTop?.constant = 30
        tagsContainerViewHeight?.constant = 90
        
        if size.width <= 375 {
            headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(30)
            topSpacerToSuperViewHeightRelation?.constant = 10
            sparklingViewToSuperViewHeightRelation?.constant = -160
            phoneViewToSparklingViewHeightRelation?.constant = -20
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 10
            sparklingViewToSuperViewHeightRelation?.constant = -50
            phoneViewToSparklingViewHeightRelation?.constant = 30
        }
    }
    
}
