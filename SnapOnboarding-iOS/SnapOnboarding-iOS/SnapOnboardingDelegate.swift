public protocol SnapOnboardingDelegate: class {
    
    func onboardingWillAppear()
    
    func termsAndConditionsTapped()
    func privacyPolicyTapped()
    
    func enableLocationServicesTapped()
    func locationServicesInstructionsTapped()
    
    func facebookSignupTapped()
    func instagramSignupTapped()
    func skipLoginTapped()
    
}
