import UIKit

extension NSMutableAttributedString {
    func bold(_ value: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize),
            .foregroundColor: UIColor.label,
            .baselineOffset: 4,
        ]
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }

    func italic(_ value: String) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize),
            .foregroundColor: UIColor.label,
            .baselineOffset: 4,
        ]
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }

    func normal(_ value: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: UIFont.systemFontSize),
            .foregroundColor: UIColor.label,
            .baselineOffset: 4,
        ]
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}