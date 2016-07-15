public protocol SnapOnboardingDelegate: class {
    
    func termsAndConditionsTapped()
    func privacyPolicyTapped()
    
    func enableLocationServicesTapped()
    
    func facebookSignupTapped()
    func instagramSignupTapped()
    
    func willDismiss()
    func didDismiss()
    
}
