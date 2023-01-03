// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import Foundation

/// Fixed size vector.
class Vec<T> {

    private var storage: UnsafeMutableBufferPointer<T>

    init(count: Int, _ f: () -> T) {
        storage = UnsafeMutableBufferPointer<T>.allocate(capacity: count)
        _ = storage.initialize(from: (0..<count).map { _ in f() })
    }

    deinit {
        storage.baseAddress?.deinitialize(count: count)
        storage.deallocate()
    }

    var count: Int { storage.count }

    subscript(index:Int) -> T {
        get {
            return storage[index]
        }
        set(newElm) {
            storage[index] = newElm
        }
    }
}

extension Vec : Sequence {

    func makeIterator() -> UnsafeMutableBufferPointer<T>.Iterator {
        return storage.makeIterator()
    }
}
