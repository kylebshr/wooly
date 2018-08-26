import UIKit

protocol Pinnable: class {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }

    var firstBaselineAnchor: NSLayoutYAxisAnchor { get }
    var lastBaselineAnchor: NSLayoutYAxisAnchor { get }

    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }

    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }

    var translatesAutoresizingMaskIntoConstraints: Bool { get set }
}

extension UIView: Pinnable {}
extension UILayoutGuide: Pinnable {
    var firstBaselineAnchor: NSLayoutYAxisAnchor {
        return bottomAnchor
    }

    var lastBaselineAnchor: NSLayoutYAxisAnchor {
        return bottomAnchor
    }

    var translatesAutoresizingMaskIntoConstraints: Bool {
        get { return false }
        set {}
    }
}

extension Pinnable {
    public func pinEdges(_ edges: UIRectEdge = .all, to object: Pinnable, insets: UIEdgeInsets = .zero) {
        let top = edges.contains(.top) ? topAnchor.pin(to: object.topAnchor, constant: insets.top) : nil
        let left = edges.contains(.left) ? leadingAnchor.pin(to: object.leadingAnchor, constant: insets.left) : nil
        let bottom = edges.contains(.bottom) ? bottomAnchor.pin(to: object.bottomAnchor, constant: -insets.bottom) : nil
        let right = edges.contains(.right) ? trailingAnchor.pin(to: object.trailingAnchor, constant: -insets.right) : nil

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([left, right, top, bottom].compactMap { $0 })
    }

    public func pinCenter(to object: Pinnable, offset: UIOffset = .zero) {
        let centerX = centerXAnchor.pin(to: object.centerXAnchor,
                                             constant: offset.horizontal)
        let centerY = centerYAnchor.pin(to: object.centerYAnchor,
                                             constant: offset.vertical)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([centerX, centerY])
    }

    public func pinSize(to object: Pinnable) {
        let height = heightAnchor.pin(to: object.heightAnchor)
        let width = widthAnchor.pin(to: object.widthAnchor)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([height, width])
    }

    public func pinSize(to size: CGSize) {
        let height = heightAnchor.pin(to: size.height)
        let width = widthAnchor.pin(to: size.width)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([height, width])
    }

    public func pinSize(to constant: CGFloat) {
        pinSize(to: CGSize(width: constant, height: constant))
    }
}

typealias XAnchorPath = KeyPath<Pinnable, NSLayoutXAxisAnchor>
typealias YAnchorPath = KeyPath<Pinnable, NSLayoutYAxisAnchor>

extension Array where Element: Pinnable {
    func align(anchors anchor: YAnchorPath) {
        guard let first = self.first else {
            return
        }

        for view in dropFirst() {
            view[keyPath: anchor].pin(to: first[keyPath: anchor])
        }
    }

    func align(anchors anchor: XAnchorPath) {
        guard let first = self.first else {
            return
        }

        for view in dropFirst() {
            view[keyPath: anchor].pin(to: first[keyPath: anchor])
        }
    }

    func pin(anchors anchor: YAnchorPath, to: YAnchorPath, spacing: CGFloat = 0) {
        var previous = first

        for view in dropFirst() {
            previous?[keyPath: anchor].pin(to: view[keyPath: to], constant: -spacing)
            previous = view
        }
    }

    func pin(anchors anchor: XAnchorPath, to: XAnchorPath, spacing: CGFloat = 0) {
        var previous = first

        for view in dropFirst() {
            previous?[keyPath: anchor].pin(to: view[keyPath: to], constant: -spacing)
            previous = view
        }
    }
}
