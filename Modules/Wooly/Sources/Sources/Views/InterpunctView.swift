import UIKit

class InterpunctView: Label {
    override init(frame: CGRect) {
        super.init(frame: frame)

        text = "·"
        pinEdges(to: self)
        setHuggingAndCompression(to: .required)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
