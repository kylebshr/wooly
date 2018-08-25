import Mammut

extension Status {
    var strippedContent: String? {
        guard let data = content.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        let htmlString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
        return htmlString?.string
    }
}