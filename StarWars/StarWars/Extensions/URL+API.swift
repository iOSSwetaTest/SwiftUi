import Foundation

extension URL {
    init?(apiPath: String) {
        self.init(string: "https://swapi.dev/api/\(apiPath)")
    }
}
