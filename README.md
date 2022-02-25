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
