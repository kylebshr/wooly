import UIKit
import Mammut

enum Appearance {
    static var scrollIndicatorStyle: UIScrollViewIndicatorStyle {
        switch ThemeController.shared.current {
        case .dark, .black: return .white
        case .light: return .black
        }
    }

    static var barStyle: UIBarStyle {
        switch ThemeController.shared.current {
        case .dark, .black: return .black
        case .light: return .default
        }
    }

    static func apply() {
        let onboardingNavigationBar = UINavigationBar.appearance(whenContainedInInstancesOf: [OnboardingViewController.self])
        onboardingNavigationBar.setBackgroundImage(UIImage(), for: .default)
        onboardingNavigationBar.shadowImage = UIImage()
        onboardingNavigationBar.barStyle = barStyle
        onboardingNavigationBar.barTintColor = .clear

        let loggedInNavigationBar = UINavigationBar.appearance()
        loggedInNavigationBar.barStyle = barStyle
        loggedInNavigationBar.barTintColor = .barColor

        let tabBar = UITabBar.appearance(whenContainedInInstancesOf: [MainTabViewController.self])
        tabBar.barStyle = barStyle
        tabBar.barTintColor = .barColor
        tabBar.unselectedItemTintColor = .textSecondary

        let scrollView = UIScrollView.appearance()
        scrollView.indicatorStyle = scrollIndicatorStyle

        let activityIndicator = UIActivityIndicatorView.appearance()
        activityIndicator.color = .textSecondary

        HandshakeService.configuration.barTintColor = .barColor
        HandshakeService.configuration.controlTintColor = .tintColor
    }
}
