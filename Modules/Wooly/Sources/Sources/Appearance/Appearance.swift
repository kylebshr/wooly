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

    static var isBarTranslucent: Bool {
        switch ThemeController.shared.current {
        case .dark, .light: return true
        case .black: return false
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
        loggedInNavigationBar.isTranslucent = isBarTranslucent

        let tabBar = UITabBar.appearance(whenContainedInInstancesOf: [MainTabViewController.self])
        tabBar.barStyle = barStyle
        tabBar.barTintColor = .barColor
        tabBar.unselectedItemTintColor = .textSecondary
        tabBar.isTranslucent = isBarTranslucent

        let scrollView = UIScrollView.appearance()
        scrollView.indicatorStyle = scrollIndicatorStyle

        let activityIndicator = UIActivityIndicatorView.appearance()
        activityIndicator.color = .textSecondary

        HandshakeService.configuration.barTintColor = .barColor
        HandshakeService.configuration.controlTintColor = .tintColor
    }
}
