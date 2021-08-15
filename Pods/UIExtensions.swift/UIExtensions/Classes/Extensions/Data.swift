import Foundation

extension Data {

    public static func toHexData(from string: String) {

    }

    public init?(hex: String) {
        let hex = hex.stripHexPrefix()

        let len = hex.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hex.index(hex.startIndex, offsetBy: i * 2)
            let k = hex.index(j, offsetBy: 2)
            let bytes = hex[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }

    public var hex: String {
        reduce("") { $0 + String(format: "%02x", $1) }
    }

    public var reversedHex: String {
        Data(self.reversed()).hex
    }

}