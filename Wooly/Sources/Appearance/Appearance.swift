import UIKit

enum Appearance {
    static var scrollIndicatorStyle: UIScrollView.IndicatorStyle {
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

    static var keyboardAppearance: UIKeyboardAppearance {
        switch ThemeController.shared.current {
        case .dark, .black: return .dark
        case .light: return .light
        }
    }

    static var statusBarStyle: UIStatusBarStyle {
        switch ThemeController.shared.current {
        case .dark, .black: return .lightContent
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
        loggedInNavigationBar.barTintColor = .bar
        loggedInNavigationBar.isTranslucent = isBarTranslucent
        loggedInNavigationBar.tintColor = .tint

        let tabBar = UITabBar.appearance()
        tabBar.barStyle = barStyle
        tabBar.barTintColor = .bar
        tabBar.unselectedItemTintColor = .textSecondary
        tabBar.isTranslucent = isBarTranslucent
        tabBar.tintColor = .tint

        let scrollView = UIScrollView.appearance()
        scrollView.indicatorStyle = scrollIndicatorStyle

        let activityIndicator = UIActivityIndicatorView.appearance()
        activityIndicator.color = .textSecondary

//        let textField = UITextField.appearance()
//        textField.keyboardAppearance = keyboardAppearance
//
//        let textView = UITextView.appearance()
//        textView.keyboardAppearance = keyboardAppearance

        HandshakeService.configuration.barTintColor = .bar
        HandshakeService.configuration.controlTintColor = .tint
    }
}
