import UIKit

enum Appearance {
    static func apply() {
        let onboardingNavigationBar = UINavigationBar.appearance(whenContainedInInstancesOf: [OnboardingViewController.self])
        onboardingNavigationBar.setBackgroundImage(UIImage(), for: .default)
        onboardingNavigationBar.shadowImage = UIImage()
        onboardingNavigationBar.barStyle = .black
        onboardingNavigationBar.barTintColor = .clear
    }
}
