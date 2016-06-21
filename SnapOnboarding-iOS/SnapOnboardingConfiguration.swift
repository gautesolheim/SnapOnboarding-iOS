import UIKit
import SnapTagsView

public struct SnapOnboardingStringsViewModel {
    
    public var termsAndPrivacyFooter: String?
    public var rangeOfTermsAndConditions: Range<String.CharacterView.Index>?
    public var rangeOfPrivacyPolicy: Range<String.CharacterView.Index>?
    
    public var next: String?
    public var introHeadline: String?
    public var tags: [SnapTagRepresentation]?
    
    public var locationHeadline: String?
    public var enableLocationServices: String?
    public var notNow: String?
    public var willAskLaterTitle: String?
    public var willAskLaterBody: String?
    public var wowYouDeclinedTitle: String?
    public var wowYouDeclinedBody: String?
    
    public var continueWithFacebook: String?
    public var continueWithInstagram: String?
    public var skipWithoutLogin: String?
    
}

public struct SnapOnboardingConfiguration {
    
    public var delegate: SnapOnboardingDelegate?
    public var stringsViewModel: SnapOnboardingStringsViewModel

}
