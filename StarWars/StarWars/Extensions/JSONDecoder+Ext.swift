import Foundation

extension KeyedDecodingContainer {
    
    func decodeArray<T: Codable>(_ type: T.Type, forKey key: Key) -> [T] {
        if let array = try? self.decode([T].self, forKey: key) {
            return array
        } else {
            return []
        }
    }
    
}
