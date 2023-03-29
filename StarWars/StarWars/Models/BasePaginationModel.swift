import Foundation

struct BasePaginationModel<T: Codable>: Codable {
    let count: Int
    let next, previous: URL?
    let results: [T]
}
