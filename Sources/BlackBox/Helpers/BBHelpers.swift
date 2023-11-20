import Foundation

extension Dictionary where Key == String, Value == Any {
    func bbLogDescription(with options: JSONSerialization.WritingOptions?) -> String {
        guard JSONSerialization.isValidJSONObject(self),
            let jsonData = try? JSONSerialization.data(withJSONObject: self,
                                                       options: options ?? []),
            let jsonString = String(data: jsonData, encoding: .utf8)
            else { return String(describing: self) }
        
        return jsonString
    }
}

public extension UInt64 {
    static var random: Self {
        random(in: min...max)
    }
}
