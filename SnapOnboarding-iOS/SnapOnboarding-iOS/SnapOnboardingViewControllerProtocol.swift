import UIKit

public enum LocationServicesStatus {
    case NotYetRequested
    case WaitingForResponse
    case Enabled
    case Disabled
}

public enum AuthorizationService {
    case Facebook
    case Instagram
    case None
}

public struct UserViewModel {
    public var firstName: String?
    public var profileImage: UIImage?

    public init() {}
}

public protocol SnapOnboardingViewControllerProtocol: class {
    
    func applyConfiguration(configuration: SnapOnboardingConfiguration)
    func applyFormerAuthorizationService(service: AuthorizationService, userViewModel: UserViewModel)
    func locationServicesStatusChanged(status: LocationServicesStatus)
    func reactivateLoginButtons()
    
}
