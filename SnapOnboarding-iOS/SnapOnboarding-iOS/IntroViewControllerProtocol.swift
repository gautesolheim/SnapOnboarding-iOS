protocol IntroViewControllerProtocol: class {
    
    var delegate: IntroViewControllerDelegate? { get set }
    
    func configureForViewModel(_ viewModel: SnapOnboardingViewModel.IntroViewModel)
    
}
