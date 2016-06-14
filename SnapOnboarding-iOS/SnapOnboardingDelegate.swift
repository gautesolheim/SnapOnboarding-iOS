import Foundation

public enum LocationServicesStatus {
    case NotRequestedYet
    case Enabled
    case Disabled
}

public protocol SnapOnboardingDelegate: class {
    
    func termsAndConditionsTapped()
    func privacyPolicyTapped()
    
    func enableLocationServicesTapped()
    
    func facebookSignupTapped()
    func instagramSignupTapped()
    
    func willDismiss()
    func didDismiss()
    
}
