import UIKit
@testable import SnapOnboarding_iOS

private class SnapOnboardingDelegateExample: SnapOnboardingDelegate {
    
    func termsAndConditionsTapped() {}
    func privacyPolicyTapped() {}
    
    func enableLocationServicesTapped() {}
    
    func facebookSignupTapped() {}
    func instagramSignupTapped() {}
    
    func willDismiss() {}
    func didDismiss() {}
    
}

func mockSnapOnboardingDelegate() -> SnapOnboardingDelegate {
    return SnapOnboardingDelegateExample()
}

func mockSnapOnboardingViewModelNorwegian() -> SnapOnboardingViewModel {
    let exampleViewController = ViewController()
    return exampleViewController.createSampleViewModelNorwegian()
}

func getSnapOnboardingViewController() -> SnapOnboardingViewController {
    let storyboard = UIStoryboard(name: "SnapOnboarding", bundle: NSBundle.mainBundle())
    return storyboard.instantiateViewControllerWithIdentifier("snapOnboardingViewController") as! SnapOnboardingViewController
}
