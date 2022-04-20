import Foundation
import UIKit

final class Cache<Key: Hashable, Value> {
	private let maxAmountOfElements: Int
	private var datesForAddedCache: [CFTimeInterval: Key] = [:]
	private var cache: [Key: Value] = [:]
	private var lock = NSLock()

	init(maxAmountOfElements: Int = 15) {
		self.maxAmountOfElements = maxAmountOfElements
	}

	func insert(_ value: Value, forKey key: Key) {
		defer { lock.unlock() }
		lock.lock()
		datesForAddedCache[CACurrentMediaTime()] = key
		cache[key] = value

		if datesForAddedCache.keys.count > maxAmountOfElements {
			guard let key = datesForAddedCache.keys.sorted(by: <).first else { return }
			if let keyToRemove = datesForAddedCache.removeValue(forKey: key) {
				cache.removeValue(forKey: keyToRemove)
			}
		}
	}

	func value(forKey key: Key) -> Value? {
		defer { lock.unlock() }
		lock.lock()
		return cache[key]
	}

	func remove(forKey key: Key) {
		defer { lock.unlock() }
		lock.lock()

		if let keyToRemove = datesForAddedCache.first(where: { $0.value == key }) {
			datesForAddedCache.removeValue(forKey: keyToRemove.key)
		}
		cache.removeValue(forKey: key)
	}

	func removeAll() {
		defer { lock.unlock() }
		lock.lock()
		cache.removeAll()
	}
}
