protocol LocationViewControllerProtocol: class {
    
    var delegate: LocationViewControllerDelegate? { get set }
    
    func configureForViewModel(_ viewModel: SnapOnboardingViewModel.LocationViewModel)
    func locationServicesStatusChanged(_ status: LocationServicesStatus)
    
}
