import XCTest
@testable import SwiftMarkTests
@testable import Version2Tests

XCTMain([
     testCase(SwiftMarkTests.allTests),
     testCase(Version2Tests.allTests)
])
