public protocol SnapOnboardingViewControllerProtocol: class {
    
    func applyConfiguration(configuration: SnapOnboardingConfiguration)
    func locationServicesStatusChanged(status: Bool)
    
}