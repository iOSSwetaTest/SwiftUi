import XCTest
@testable import StarWars
import Foundation
import Combine

final class StarWarTests: XCTestCase {
    
    func testPeopleApiWithTimeout() {
        let timeout: Double = 5 // Seconds
        let url = URL(string: "https://swapi.dev/api/people/?page=1")!
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = timeout
        let session = URLSession(configuration: configuration)
        let publisher = session.dataTaskPublisher(for: url)
            .map { data, response in
                return data
            }
            .decode(type: BasePaginationModel<CharacterInfo>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
        
        let expectation = XCTestExpectation(description: "Response received")
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    if let error = error as? URLError,
                       error.code == .timedOut {
                        XCTFail("Request Timeout: \(error.localizedDescription)")
                    } else {
                        XCTFail("Request failed with error: \(error.localizedDescription)")
                    }
                case .finished:
                    expectation.fulfill()
                }
            },
            receiveValue: { info in
                XCTAssertGreaterThan(info.results.count, 0)
            }
        )
        wait(for: [expectation], timeout: 60)
        cancellable.cancel()
    }
    
}
