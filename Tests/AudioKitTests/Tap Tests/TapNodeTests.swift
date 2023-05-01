// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit
import XCTest

class TapNodeTests: XCTestCase {
    func testTapNode() async throws {
        let engine = Engine()
        let noise = Noise()
        noise.amplitude = 0.1
        let tapNode = Tap(noise, bufferSize: 256) { left, right in
            print("left.count: \(left.count), right.count: \(right.count)")
            print(detectAmplitudes([left, right]))
        }
        engine.output = tapNode

        try engine.start()
        sleep(1)
    }

    func testTap2() async throws {
        let engine = Engine()
        let noise = Noise()
        noise.amplitude = 0.1

        let expectation = XCTestExpectation(description: "tap callback called")
        let tap: Tap2? = Tap2(noise) { l, r in
            print("left.count: \(l.count), right.count: \(r.count)")
            print(detectAmplitudes([l, r]))
            expectation.fulfill()
        }
        engine.output = noise

        try engine.start()
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertNotNil(tap) // keep tap alive
    }
}
