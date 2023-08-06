// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit
import AVFAudio
import XCTest

class ManualRenderingTests: XCTestCase {
    func testManualRenderingInput() throws {
        let frameCount: AVAudioFrameCount = 10
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 2)!
        let inputBuf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
        let outputBuf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
        inputBuf.frameLength = frameCount
        outputBuf.frameLength = frameCount

        inputBuf.floatChannelData![0][0] = 42.0

        let engine = AudioEngine()
        try engine.avEngine.enableManualRenderingMode(.realtime,
                                                      format: format,
                                                      maximumFrameCount: frameCount)

        engine.output = engine.input
        engine.avEngine.inputNode.setManualRenderingInputPCMFormat(format) { _ in
            inputBuf.audioBufferList
        }

        try engine.start()

        var err: OSStatus = 0
        let status = engine.avEngine.manualRenderingBlock(frameCount, outputBuf.mutableAudioBufferList, &err)

        XCTAssertEqual(status, .success)
        XCTAssertEqual(err, noErr)

        XCTAssertEqual(outputBuf.floatChannelData![0][0], 42.0)
    }
}
