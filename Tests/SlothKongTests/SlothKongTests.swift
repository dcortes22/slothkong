import XCTest
import Combine

@testable import SlothKong

final class SlothKongTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func testQueryParametersPost() throws {
        var error: SlothError?
        var posts = [Post]()
        let expectation = self.expectation(description: "PostsTimeout")
        
        PostsEndpoint.query.requestPublisher([Post].self)
            .sink { result in
                switch result {
                case .failure(let encounteredError):
                    error = encounteredError
                case .finished:
                    break
                }
                expectation.fulfill()
            } receiveValue: { value in
                posts = value
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        XCTAssertNil(error)
        XCTAssertEqual(posts.first?.userId, 2)
    }
    
    func test404Error() throws {
        var error: SlothError?

        let expectation = self.expectation(description: "PostsTimeout")
        
        PostsEndpoint.notfound.requestPublisher([Post].self)
            .sink{ result in
                switch result {
                case .failure(let encounteredError):
                    error = encounteredError
                case .finished:
                    break
                }
                expectation.fulfill()
            } receiveValue: { _ in
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 20)
        let expected = SlothError.connectionFailed(reason: .internalError(404))
        XCTAssertEqual(error, expected)
    }
    
    func testTimeOutError() throws {
        var error: SlothError?

        let expectation = self.expectation(description: "PostsTimeout")
        
        PostsEndpoint.timeout.requestPublisher([Post].self)
            .sink{ result in
                switch result {
                case .failure(let encounteredError):
                    error = encounteredError
                case .finished:
                    break
                }
                expectation.fulfill()
            } receiveValue: { _ in
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 20)
        let expected = SlothError.connectionFailed(reason: .timeout)
        XCTAssertEqual(error, expected)
    }
    
    func testGetPostRequestPublisher() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        var posts = [Post]()
        var error: SlothError?
        
        let expectation = self.expectation(description: "Posts")
        
        PostsEndpoint.posts.requestPublisher([Post].self)
            .sink { result in
                switch result {
                case .failure(let encounteredError):
                    error = encounteredError
                case .finished:
                    break
                }
                expectation.fulfill()
            } receiveValue: { value in
                posts = value
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        XCTAssertEqual(posts.first?.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
    }
}
