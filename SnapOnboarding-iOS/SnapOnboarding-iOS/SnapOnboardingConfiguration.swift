import UIKit
import SnapTagsView

public struct SnapOnboardingViewModel {
    
    public struct TermsViewModel {
        public var termsAndPrivacyFooter: String?
        public var rangeOfTermsAndConditions: Range<String.CharacterView.Index>?
        public var rangeOfPrivacyPolicy: Range<String.CharacterView.Index>?
        
        public init() {}
    }
    
    public struct IntroViewModel {
        public var next: String?
        public var introHeadline: String?
        public var tags: [SnapTagRepresentation]?
        
        public init() {}
    }
    
    public struct LocationViewModel {
        public var next: String?
        public var locationHeadline: String?
        public var enableLocationServices: String?
        public var notNow: String?
        public var willAskLaterTitle: String?
        public var willAskLaterBody: String?
        public var wowYouDeclinedTitle: String?
        public var wowYouDeclinedBody: String?
        public var didEnableLocationServicesTitle: String?
        public var didEnableLocationServicesBody: String?
        
        public init() {}
    }
    
    public struct LoginViewModel {
        public var continueWithFacebook: String?
        public var continueWithInstagram: String?
        public var skipWithoutLogin: String?
        
        public init() {}
    }
    
    public var termsViewModel: TermsViewModel
    public var introViewModel: IntroViewModel
    public var locationViewModel: LocationViewModel
    public var loginViewModel: LoginViewModel
    
    public init(termsViewModel: TermsViewModel, introViewModel: IntroViewModel, locationViewModel: LocationViewModel, loginViewModel: LoginViewModel) {
        self.termsViewModel = termsViewModel
        self.introViewModel = introViewModel
        self.locationViewModel = locationViewModel
        self.loginViewModel = loginViewModel
    }
    
}

public struct SnapOnboardingConfiguration {
    
    public var delegate: SnapOnboardingDelegate?
    public var viewModel: SnapOnboardingViewModel
    
    public init(delegate: SnapOnboardingDelegate?, viewModel: SnapOnboardingViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
    }

}
