import UIKit

public enum LocationServicesStatus {
    case notYetRequested
    case waitingForResponse
    case enabled
    case disabled
}

public enum AuthorizationService {
    case facebook
    case instagram
    case none
}

public struct UserViewModel {
    public let profileImageURL: URL?

    public init(profileImageURL: URL?) {
        self.profileImageURL = profileImageURL
    }
}

public protocol SnapOnboardingViewControllerProtocol: class {
    
    func applyConfiguration(_ configuration: SnapOnboardingConfiguration)
    func applyFormerAuthorizationService(_ service: AuthorizationService, userViewModel: UserViewModel)
    func locationServicesStatusChanged(_ status: LocationServicesStatus)
    func reactivateLoginButtons()

    func startAnimations()
    func stopAnimations()
    
}
