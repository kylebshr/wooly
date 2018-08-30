struct AnyWeak: Hashable {
    let hashValue: Int

    weak var object: AnyObject?

    init<T: AnyObject>(_ object: T) where T: Hashable {
        self.object = object
        self.hashValue = object.hashValue
    }

    static func == (lhs: AnyWeak, rhs: AnyWeak) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

class Observable<T: Equatable> {
    private var observers: [AnyWeak: [(T) -> Void]] = [:]

    var current: T {
        didSet { if oldValue != current { notify() } }
    }

    func add<U: AnyObject>(_ observer: U, handler: @escaping (T) -> Void) where U: Hashable {
        handler(current)
        let key = AnyWeak(observer)
        var handlers = observers[key] ?? []
        handlers.append(handler)
        observers[key] = handlers
    }

    func remove<U: AnyObject>(_ observer: U) where U: Hashable {
        observers[AnyWeak(observer)] = nil
    }

    init(initial: T) {
        self.current = initial
    }

    private func notify() {
        var discard: [AnyWeak] = []

        for observer in observers {
            guard observer.key.object != nil else {
                discard.append(observer.key)
                continue
            }

            for handler in observer.value {
                handler(current)
            }
        }

        for object in discard {
            observers[object] = nil
        }
    }
}
