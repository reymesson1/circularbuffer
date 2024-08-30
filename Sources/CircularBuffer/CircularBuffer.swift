import Foundation

enum CircularBufferError: Error {
    case bufferFull
    case bufferEmpty
}

struct CircularBuffer<T> {
    private var buffer: [T?]
    private var capacity: Int
    private var head: Int
    private var tail: Int
    private var count: Int

    init(capacity: Int) {
        self.capacity = capacity
        self.buffer = [T?](repeating: nil, count: capacity)
        self.head = 0
        self.tail = 0
        self.count = 0
    }

    mutating func write(_ item: T) throws {
        if count == capacity {
            throw CircularBufferError.bufferFull
        }

        buffer[head] = item
        head = (head + 1) % capacity
        count += 1
    }

    mutating func read() throws -> T {
        if count == 0 {
            throw CircularBufferError.bufferEmpty
        }

        let item = buffer[tail]
        buffer[tail] = nil
        tail = (tail + 1) % capacity
        count -= 1

        return item!
    }

    mutating func overwrite(_ item: T) {
        if count == capacity {
            tail = (tail + 1) % capacity
        } else {
            count += 1
        }
        buffer[head] = item
        head = (head + 1) % capacity
    }

    mutating func clear() {
        buffer = [T?](repeating: nil, count: capacity)
        head = 0
        tail = 0
        count = 0
    }
}
