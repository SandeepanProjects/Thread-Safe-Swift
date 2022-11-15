//
//  ThreadSafeDictionary.swift
//  MinCostPath
//
//  Created by sandeepan swain on 15/11/22.
//

import Foundation


class SafeDict {
    private var threadUnsafeDict = [String: String]()
    private let dispatchQueue = DispatchQueue(label: "com.amrit.magicDictionary", attributes: .concurrent)

    func getValue(key: String) -> String? {
        var result: String?
        dispatchQueue.sync {
            result = threadUnsafeDict[key]
        }
        return result
    }

    func setObject(key: String, value: String?) {
        dispatchQueue.async(flags: .barrier) {
            self.threadUnsafeDict[key] = value
        }
    }
}

//===============================================================================================

class ThreadSafeDictionary<V: Hashable,T>: Collection {

    private var dictionary: [V: T]
    private let concurrentQueue = DispatchQueue(label: "Dictionary Barrier Queue",
                                                attributes: .concurrent)
    var startIndex: Dictionary<V, T>.Index {
        self.concurrentQueue.sync {
            return self.dictionary.startIndex
        }
    }

    var endIndex: Dictionary<V, T>.Index {
        self.concurrentQueue.sync {
            return self.dictionary.endIndex
        }
    }

    init(dict: [V: T] = [V:T]()) {
        self.dictionary = dict
    }
    // this is because it is an apple protocol method
    // swiftlint:disable identifier_name
    func index(after i: Dictionary<V, T>.Index) -> Dictionary<V, T>.Index {
        self.concurrentQueue.sync {
            return self.dictionary.index(after: i)
        }
    }
    // swiftlint:enable identifier_name
    subscript(key: V) -> T? {
        set(newValue) {
            self.concurrentQueue.async(flags: .barrier) {[weak self] in
                self?.dictionary[key] = newValue
            }
        }
        get {
            self.concurrentQueue.sync {
                return self.dictionary[key]
            }
        }
    }

    // has implicity get
    subscript(index: Dictionary<V, T>.Index) -> Dictionary<V, T>.Element {
        self.concurrentQueue.sync {
            return self.dictionary[index]
        }
    }
    
    func removeValue(forKey key: V) {
        self.concurrentQueue.async(flags: .barrier) {[weak self] in
            self?.dictionary.removeValue(forKey: key)
        }
    }

    func removeAll() {
        self.concurrentQueue.async(flags: .barrier) {[weak self] in
            self?.dictionary.removeAll()
        }
    }
}
