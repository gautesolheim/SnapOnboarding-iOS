protocol LocationViewControllerProtocol: class {
    
    func configureForViewModel(viewModel: SnapOnboardingViewModel.LocationViewModel)
    func locationServicesStatusChanged(status: Bool)
    
}