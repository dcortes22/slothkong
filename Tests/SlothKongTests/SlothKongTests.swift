import XCTest
import Combine

@testable import SlothKong

final class SlothKongTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func testRequestMethodValid() throws {
        XCTAssertEqual(try! MockEndpointSuccess.list.asURLRequest().httpMethod, "GET")
    }
    
    func testQueryParameters() throws {
        let url = try! MockEndpointSuccess.list.asURLRequest().url?.absoluteString
        XCTAssertEqual(url, "http://url.com/?user=1")
        
    }
    
    func testBodyParameters() throws {
        let data = try! MockEndpointSuccess.new.asURLRequest().httpBody
        XCTAssertNotEqual(data, nil)
        
    }
    
    func testHeaders() throws {
        let headers = try! MockEndpointSuccess.list.asURLRequest().allHTTPHeaderFields
        XCTAssertNotEqual(headers, nil)
        
    }
    
    func test404Error() throws {
        var error: SlothError?

        let expectation = self.expectation(description: "Error 404")

        MockEndpointInvalid.errorNotFound.requestPublisher([MockModel].self)
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
    
    func testGetPostRequestPublisher() throws {
        var posts = [MockModel]()
        var error: SlothError?
        
        let expectation = self.expectation(description: "Posts")
        
        MockEndpointSuccess.list.requestPublisher([MockModel].self)
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
        
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(error)
        XCTAssertEqual(posts.count, 2)
    }
}
