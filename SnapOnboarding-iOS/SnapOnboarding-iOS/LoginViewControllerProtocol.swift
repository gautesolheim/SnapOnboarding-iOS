protocol LoginViewControllerProtocol: class {
    
    var delegate: LoginViewControllerDelegate? { get set }
    
    func configureForViewModel(viewModel: SnapOnboardingViewModel.LoginViewModel)
    func reactivateLoginButtons()
    
}