import Flutter
import UIKit
import XCTest

@testable import social_bridge

class RunnerTests: XCTestCase {

  func testUnhandledMethod() {
    let plugin = SocialBridgePlugin()

    let call = FlutterMethodCall(methodName: "unhandledMethod", arguments: [])

    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(call) { result in
      XCTAssertTrue((result as? NSObject) == FlutterMethodNotImplemented)
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

}
