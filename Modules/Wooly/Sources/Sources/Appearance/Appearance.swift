import UIKit
import Mammut

enum Appearance {
    static func apply() {
        let onboardingNavigationBar = UINavigationBar.appearance(whenContainedInInstancesOf: [OnboardingViewController.self])
        onboardingNavigationBar.setBackgroundImage(UIImage(), for: .default)
        onboardingNavigationBar.shadowImage = UIImage()
        onboardingNavigationBar.barStyle = .black
        onboardingNavigationBar.barTintColor = .clear

        let loggedInNavigationBar = UINavigationBar.appearance(whenContainedInInstancesOf: [LoggedInViewController.self])
        loggedInNavigationBar.barStyle = .black
        loggedInNavigationBar.barTintColor = .barColor

        let tabBar = UITabBar.appearance(whenContainedInInstancesOf: [LoggedInViewController.self])
        tabBar.barStyle = .black
        tabBar.barTintColor = .barColor

        HandshakeService.configuration.barTintColor = .barColor
        HandshakeService.configuration.controlTintColor = .white
    }
}
