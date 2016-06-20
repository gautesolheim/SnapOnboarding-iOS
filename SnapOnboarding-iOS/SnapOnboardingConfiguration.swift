import Foundation
import UIKit

public struct SnapOnboardingStringsViewModel {
    public var disclaimerLineOne: String?
    public var termsOfConditions: String?
    public var and: String?
    public var privacyPolicy: String?
    public var next: String?
    
    public var introHeadline: String?
    public var tags: [String]?
    
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
    public var backgroundColor: UIColor

}
