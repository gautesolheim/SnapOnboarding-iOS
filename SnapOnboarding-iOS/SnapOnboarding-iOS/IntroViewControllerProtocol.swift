protocol IntroViewControllerProtocol: class {
    
    var delegate: IntroViewControllerDelegate? { get set }
    
    func configureForViewModel(viewModel: SnapOnboardingViewModel.IntroViewModel)
    
}