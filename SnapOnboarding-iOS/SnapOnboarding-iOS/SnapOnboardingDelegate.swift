public protocol SnapOnboardingDelegate: class {
    
    func termsAndConditionsTapped()
    func privacyPolicyTapped()
    
    func enableLocationServicesTapped()
    func locationServicesInstructionsTapped()
    
    func facebookSignupTapped()
    func instagramSignupTapped()
    func skipLoginTapped()
    
}
