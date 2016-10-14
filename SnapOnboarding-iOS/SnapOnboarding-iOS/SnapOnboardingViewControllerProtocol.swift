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
    public let profileImageURL: NSURL?

    public init(profileImageURL: NSURL?) {
        self.profileImageURL = profileImageURL
    }
}

public protocol SnapOnboardingViewControllerProtocol: class {
    
    func applyConfiguration(configuration: SnapOnboardingConfiguration)
    func applyFormerAuthorizationService(service: AuthorizationService, userViewModel: UserViewModel)
    func locationServicesStatusChanged(status: LocationServicesStatus)
    func reactivateLoginButtons()

    func startAnimations()
    func stopAnimations()
    
}
