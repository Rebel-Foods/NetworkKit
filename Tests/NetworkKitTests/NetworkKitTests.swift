import XCTest
import Combine
@testable import NetworkKit

enum APIVersion: String, APIRepresentable {
    case v1 = "5da1e9ae76c28f0014bbe25f"
    
    var subUrl: String {
        return "\(rawValue)"
    }
    
    var endPoint: String {
        switch self {
        case .v1: return ""
        }
    }
}

enum Host: String, HostRepresentable {
    
    case server = "mockapi.io"
    
    var host: String { rawValue }
    
    var defaultHeaders: HTTPHeaderParameters { [:] }
    
    var defaultAPIVersion: APIRepresentable? { APIVersion.v1 }
    
    var defaultUrlQuery: URLQuery? { nil }
}

extension Environment {
    static let production = Environment(value: "")
}

enum MockPoint: ConnectionRepresentable {
    
    case allUsers
    
    var path: String { "/users" }
    
    var name: String? { "Users" }
    
    var method: HTTPMethod { .get }
    
    var httpHeaders: HTTPHeaderParameters { [:] }
    
    var host: HostRepresentable { Host.server }
    
    var defaultQuery: URLQuery? { nil }
    
}

enum MockPointError: ConnectionRepresentable {
    
    case allUsers
    
    var path: String { "/users1" }
    
    var name: String? { "Users" }
    
    var method: HTTPMethod { .get }
    
    var httpHeaders: HTTPHeaderParameters { [:] }
//
    var host: HostRepresentable { Host.server }
    
    var defaultQuery: URLQuery? { nil }
    
}

struct User: Codable, Equatable {
    let id, createdAt, name: String?
    let avatar: String?
}

typealias Users = [User]

final class NetworkKitTests: XCTestCase {
    
    var users: Users = [] {
        willSet {
//            print("Setting new Value\n\n\n\(newValue)")
//            expecatation.fulfill()
        }
    }
    
    var cancellable: NetworkCancellable?
    
    @available(OSX 10.15, *)
    func testURLSession() {
        _ = URLSession.shared.dataTaskPublisher(for: URL(string: "")!)
    }
    
    func testExample() {
        let expecatation = XCTestExpectation()
        
        cancellable = NetworkKit {
            NetworkRequest(to: MockPointError.allUsers)
        }
        .validate()
        .tryCatch { (error) in
            NetworkKit {
                NetworkRequest(to: MockPoint.allUsers)
            }
        }
        .map(\.data)
        .decode(type: Users.self, decoder: JSONDecoder())
        .completion { (_) in
            expecatation.fulfill()
        }
        
        
        
        
//        .completion { (result) in
//            switch result {
//            case .success:
//                XCTAssert(true)
//
//            case .failure:
//                XCTAssert(false)
//
//            }
//            expecatation.fulfill()
//        }
        
        wait(for: [expecatation], timeout: 60)
    }
    
    func testPerformanceExample() {
        measure {
            testExample()
        }
    }
    
    static var allTests = [
        ("testExample", testExample, "testPerformanceExample", testPerformanceExample),
    ]
}
