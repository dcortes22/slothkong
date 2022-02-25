# SlothKong

[![Swift](https://img.shields.io/badge/Swift-5.3_5.4_5.5-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.3_5.4_5.5-Orange?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS-orange?style=flat-square)](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS-orange?style=flat-square)
[![Twitter](https://img.shields.io/badge/twitter-@dcortes22-blue.svg?style=flat-square)](https://twitter.com/dcortes22)

![SlothKong](https://raw.githubusercontent.com/dcortes22/slothkong/master/sloth.jpeg)

A small HTTP library written in Swift that supports Combine and Async/Await.

## Requirements

- iOS 13 or higher
- tvOS 13 or higher
- macOS 11 or higher
- watchOS 6 or higher

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding Alamofire as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/dcortes22/slothkong", .upToNextMajor(from: "1.0.0"))
]
```

## How to use

SlothKong use the Endpoint enum to generate Http calls and return publishers.

### Endpoint Definition

First define a Endpoint with all your verbs, parameters, paths and headers

```swift
enum PostsEndpoint: Endpoint {
    
    case get
    case multipart
    case post(post: Post)
    
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com/")!
    }
    
    var path: String {
        switch self {
        case .get, .post(_):
            return "posts"
        case .multipart:
            return "posts/multipart"
        }
        
    }
    
    var parameters: Parameters? {
        switch self {
        case .get:
            return nil
        case .multipart:
            var parameters = Parameters()
            parameters["userId"] = 2
            return parameters
        case .post(post: let post):
            var parameters = Parameters()
            parameters["userId"] = post.userId
            parameters["body"] = post.body
            parameters["title"] = post.title
            return parameters
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .multipart, .post(_):
            return .post
        default:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
```

With a defined endpoint, the publisher can already be obtained according to the needs

For example for a post verb

```swift
PostsEndpoint.post(post: post).requestPublisher(Post.self)
    .receive(on: OperationQueue.main)
    .sink { completion in
        switch completion {
        case .failure(let encounteredError):
            error = encounteredError
        case .finished:
            break
        }
    } receiveValue: { post in
        responsePost = post
    }
    .store(in: &cancellables)
```

If you want to list using a get

```swift
PostsEndpoint.get.requestPublisher([Post].self)
    .receive(on: OperationQueue.main)
    .sink { completion in
        switch completion {
        case .failure(let encounteredError):
            error = encounteredError
        case .finished:
            break
        }
    } receiveValue: { posts in
        responsePosts = posts
    }
    .store(in: &cancellables)
```

If you need to upload a resource with multipart form, you can use the Multipart object. Make sure to receive on main queue, to get the upload progress.

```swift
let multipartData = MultipartData(data: imageData, mimeType: .jpeg, fileName: "test", name: "Test")

PostsEndpoint.multipart.requestPublisher(multipartData)
    .receive(on: OperationQueue.main)
    .sink { result in
        switch result {
        case .failure(let encounteredError):
            error = encounteredError
        case .finished:
            break
        }
    } receiveValue: { uploadResponse in
        switch uploadResponse {
        case let .progress(percentage):
            print("Porcentaje \(percentage)")
            expectation.fulfill()
            break
        case let .response(data):
            print("Data \(data)")
            expectation.fulfill()
            break
        }
    }
    .store(in: &cancellables)
```
