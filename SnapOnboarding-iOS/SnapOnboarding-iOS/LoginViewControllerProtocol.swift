protocol LoginViewControllerProtocol: class {
    
    var delegate: LoginViewControllerDelegate? { get set }
    
    func configureForViewModel(_ viewModel: SnapOnboardingViewModel.LoginViewModel)
    func applyFormerAuthorizationService(_ formerAuthorizationService: AuthorizationService, userViewModel: UserViewModel)
    func reactivateLoginButtons()
    
}
