protocol LocationViewControllerProtocol: class {
    
    var delegate: LocationViewControllerDelegate? { get set }
    
    func configureForViewModel(viewModel: SnapOnboardingViewModel.LocationViewModel)
    func locationServicesStatusChanged(status: SnapOnboardingLocationServicesStatus)
    
}