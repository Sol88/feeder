import Foundation

final class Cache<Key: Hashable, Value> {
	private var cache: [Key: Value] = [:]
	private var lock = NSLock()

	func insert(_ value: Value, forKey key: Key) {
		defer { lock.unlock() }
		lock.lock()
		cache[key] = value
	}

	func value(forKey key: Key) -> Value? {
		defer { lock.unlock() }
		lock.lock()
		return cache[key]
	}

	func remove(forKey key: Key) {
		defer { lock.unlock() }
		lock.lock()
		cache.removeValue(forKey: key)
	}

	func removeAll() {
		defer { lock.unlock() }
		lock.lock()
		cache.removeAll()
	}
}
