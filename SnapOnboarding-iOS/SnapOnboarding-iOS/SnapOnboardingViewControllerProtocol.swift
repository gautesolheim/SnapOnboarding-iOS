public enum LocationServicesStatus {
    case NotYetRequested
    case WaitingForResponse
    case Enabled
    case Disabled
}

public protocol SnapOnboardingViewControllerProtocol: class {
    
    func applyConfiguration(configuration: SnapOnboardingConfiguration)
    func locationServicesStatusChanged(status: LocationServicesStatus)
    func reactivateLoginButtons()
    
}