
import Foundation
import Firebase
import GoogleMaps


class AuthRouter {

    var handle: AuthStateDidChangeListenerHandle?

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser == nil {
                self.navigateToLoginStoryboard()
            } else {
                self.navigateToMapStoryboard()
            }
        }
    }

    private func navigateToLoginStoryboard() {
        let loginVC = Storyboard.login.instanceOf(viewController: LoginViewController.self, identifier: "LoginViewController")!
        navigationController.pushViewController(loginVC, animated: true)
       }

    private func navigateToMapStoryboard() {
        let mapVC = Storyboard.map.instanceOf(viewController: MapViewController.self, identifier: "MapViewController")!
        navigationController.pushViewController(mapVC, animated: true)
    }
}
