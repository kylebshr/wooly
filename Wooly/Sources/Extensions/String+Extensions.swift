import Foundation
import HTMLString

extension String {

    var base64Decoded: String? {
        if let decodedData = Data(base64Encoded: self),
            let decodedString = String(data: decodedData, encoding: .utf8) {
            return decodedString
        } else {
            return nil
        }
    }

    func removingHTML() -> String {
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = nil

        var pureString = String()
        var tmp: NSString?

        while !scanner.isAtEnd {
            scanner.scanUpTo("<", into: &tmp)

            if let tmp = tmp {
                pureString.append(tmp as String)
            }

            tmp = nil
            scanner.scanUpTo(">", into: &tmp)

            if let tmp = tmp {
                if tmp == "<br /" || tmp == "<br" {
                    pureString.append("\n")
                } else if tmp == "</p" && scanner.scanLocation + 1 != (self as NSString).length {
                    pureString.append("\n\n")
                }
            }

            if !scanner.isAtEnd {
                tmp = nil
                scanner.scanLocation += 1
            }
        }

        return pureString.removingHTMLEntities
    }

    func convertingShortnameToUnicode() -> String {
        var unicodeString = self
        let matches = String.emojiRegex.matches(in: self, options: [], range: NSRange(location: 0, length: count))

        for result in matches.reversed() {
            if result.numberOfRanges < 2 {
                continue
            }

            if let range = Range(result.range(at: 1), in: self),
                let emoji = String.emojiMapping[String(self[range])],
                let replace = Range(result.range(at: 0), in: self) {
                unicodeString = unicodeString.replacingCharacters(in: replace, with: emoji)
            }
        }

        return unicodeString
    }
}
