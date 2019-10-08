import XCTest

import LexerTests
import SwiftMarkTests

var tests = [XCTestCaseEntry]()
tests += LexerTests.__allTests()
tests += SwiftMarkTests.__allTests()

XCTMain(tests)
