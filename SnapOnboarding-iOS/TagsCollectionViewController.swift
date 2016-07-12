import SnapTagsView
import SnapFonts_iOS

struct TagsViewModel {
    var data: [SnapTagRepresentation]?
}

class TagsCollectionViewController: SnapTagsCollectionViewController {
    
    private var fontSize: CGFloat = 13
    private var spacing: CGFloat = 10
    private var insets = UIEdgeInsets(top: 8.5, left: 9.5, bottom: 8.5, right: 9.5)
    
    func configureForViewModel(viewModel: TagsViewModel) {
        data = viewModel.data ?? [SnapTagRepresentation]()
    }
    
    override func viewDidLoad() {
        configuration = createConfiguration()
        buttonConfiguration = createButtonConfiguration()
        
        super.viewDidLoad()
        
        setupForScreenSize(SnapOnboardingViewController.screenSize)
        scrollEnabled = false
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        setupForScreenSize(size)
    }
    
    func createConfiguration() -> SnapTagsViewConfiguration {
        var config = SnapTagsViewConfiguration()
        config.spacing = spacing
        config.horizontalMargin = 0
        config.verticalMargin = 0
        config.contentHeight = fontSize
        config.alignment = .Center
        
        return config
    }
    
    func createButtonConfiguration() -> SnapTagButtonConfiguration {
        var config = SnapTagButtonConfiguration()
        config.font = SnapFonts.gothamRoundedMediumOfSize(fontSize)
        config.canBeTurnedOnAndOff = true
        config.margin = UIEdgeInsetsZero
        config.labelInset = insets
        
        var onState = ButtonStateConfiguration()
        onState.buttonImage = UIImage.SnapTagsViewAssets.YellowCloseButton.image
        onState.backgroundColor = UIColor.whiteColor()
        onState.textColor = UIColor.blackColor()
        onState.hasButton = false
        onState.cornerRadius = 4
        
        var offState = onState
        offState.buttonImage = UIImage.SnapTagsViewAssets.RedCloseButton.image
        offState.buttonTransform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(M_PI * 45 / 180.0))
        offState.backgroundColor = UIColor.whiteColor()
        offState.textColor = UIColor.roseColor()
        offState.borderColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
        offState.borderWidth = 0
        
        var highlightedOnState = onState
        highlightedOnState.backgroundColor = UIColor(red: 229/255.0, green: 0/255.0, blue: 79/255.0, alpha: 1)
        
        let highlightedOffState = highlightedOnState
        
        config.onState = onState
        config.offState = offState
        config.highlightedWhileOnState = highlightedOnState
        config.highlightedWhileOffState = highlightedOffState
        
        return config
    }
    
}

// MARK: ScreenSizesProtocol

extension TagsCollectionViewController {
    
    func setupForIpadPortrait(size: CGSize) {
        fontSize = 15
        spacing = 12
        insets = UIEdgeInsets(top: 9.5, left: 10.5, bottom: 9.5, right: 10.5)
    }
    
}
