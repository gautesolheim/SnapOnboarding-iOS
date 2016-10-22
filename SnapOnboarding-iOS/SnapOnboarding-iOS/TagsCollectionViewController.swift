import SnapTagsView
import SnapFonts_iOS

struct TagsViewModel {
    var data: [SnapTagRepresentation]?
}

class TagsCollectionViewController: SnapTagsCollectionViewController {
    
    fileprivate var fontSize: CGFloat = 13
    fileprivate var spacing: CGFloat = 10
    fileprivate var insets = UIEdgeInsets(top: 7.0, left: 9.5, bottom: 7.0, right: 9.5)
    
    func configureForViewModel(_ viewModel: TagsViewModel) {
        data = viewModel.data ?? [SnapTagRepresentation]()
    }
    
    override func viewDidLoad() {
        setupForScreenSize(SnapOnboardingViewController.screenSize)
        configuration = createConfiguration()
        buttonConfiguration = createButtonConfiguration()
        
        super.viewDidLoad()
    }
    
    func createConfiguration() -> SnapTagsViewConfiguration {
        let shadowWidth: CGFloat = 3
        let shadowHeight: CGFloat = 3
        
        var config = SnapTagsViewConfiguration()
        config.spacing = spacing - (shadowWidth + shadowHeight)
        config.horizontalMargin = 0 - shadowWidth
        config.verticalMargin = 0 - shadowHeight
        config.alignment = .center
        
        return config
    }
    
    func createButtonConfiguration() -> SnapTagButtonConfiguration {
        var config = SnapTagButtonConfiguration()
        config.font = SnapFonts.gothamRoundedMediumOfSize(fontSize)
        config.margin = UIEdgeInsets.zero
        
        // Account for shadows on background image
        var newInsets = insets
        newInsets.bottom += 3
        newInsets.top += 3
        newInsets.left += 3
        newInsets.right += 3.5
        config.labelInset = newInsets
        
        var onState = ButtonStateConfiguration()
        onState.backgroundColor = UIColor.clear
        onState.backgroundImage = Asset.Tags_background.image
        onState.textColor = UIColor.black
        onState.cornerRadius = 4
        
        var offState = onState
        offState.buttonTransform = CGAffineTransform.identity.rotated(by: CGFloat(M_PI * 45 / 180.0))
        offState.backgroundColor = UIColor.white
        offState.textColor = UIColor.roseColor
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
    
    func setupForIpadPortrait(_ size: CGSize) {
        setupForIpad()
    }
    
    func setupForIpadLandscape(_ size: CGSize) {
        setupForIpad()
    }
    
    func setupForIpadProPortrait(_ size: CGSize) {
        setupForIpadPro()
    }
    
    func setupForIpadProLandscape(_ size: CGSize) {
        setupForIpadPro()
    }
    
    // MARK: Helpers
    
    fileprivate func setupForIpad() {
        fontSize = 15
        spacing = 12
        insets = UIEdgeInsets(top: 8.0, left: 10.5, bottom: 8.0, right: 10.5)
    }
    
    fileprivate func setupForIpadPro() {
        fontSize = 17
        spacing = 14
        insets = UIEdgeInsets(top: 9.0, left: 11.5, bottom: 9.0, right: 11.5)
    }
    
}
