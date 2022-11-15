//
//  ThreadSafePhoneBookHashable.swift
//  MinCostPath
//
//  Created by sandeepan swain on 15/11/22.
//

import Foundation


public class Person {
    public let name: String
    public let phoneNumber: String
    
    public init(name: String, phoneNumber: String) {
        self.name = name
        self.phoneNumber = phoneNumber
    }
    
    public static func uniquePerson() -> Person {
        let randomID = UUID().uuidString
        return Person(name: randomID, phoneNumber: randomID)
    }
}

extension Person: CustomStringConvertible {
    public var description: String {
        return "Person: \(name), \(phoneNumber)"
    }
}

public enum ThreadSafety { // Changed the name from Qos, because this has nothing to do with quality of service, but is just a question of thread safety
    case threadSafe, none
}

public class PhoneBook {
    
    private var threadSafety: ThreadSafety
    private var nameToPersonMap = [String: Person]()        // if you're synchronizing these, you really shouldn't expose them to the public
    private var phoneNumberToPersonMap = [String: Person]() // if you're synchronizing these, you really shouldn't expose them to the public
    private var readWriteLock = ReaderWriterLock()
    
    public init(_ threadSafety: ThreadSafety) {
        self.threadSafety = threadSafety
    }
    
    public func personByName(_ name: String) -> Person? {
        if threadSafety == .threadSafe {
            return readWriteLock.concurrentlyRead { [weak self] in
                self?.nameToPersonMap[name]
            }
        } else {
            return nameToPersonMap[name]
        }
    }
    
    public func personByPhoneNumber(_ phoneNumber: String) -> Person? {
        if threadSafety == .threadSafe {
            return readWriteLock.concurrentlyRead { [weak self] in
                self?.phoneNumberToPersonMap[phoneNumber]
            }
        } else {
            return phoneNumberToPersonMap[phoneNumber]
        }
    }
    
    public func addPerson(_ person: Person) {
        if threadSafety == .threadSafe {
            readWriteLock.exclusivelyWrite { [weak self] in
                self?.nameToPersonMap[person.name] = person
                self?.phoneNumberToPersonMap[person.phoneNumber] = person
            }
        } else {
            nameToPersonMap[person.name] = person
            phoneNumberToPersonMap[person.phoneNumber] = person
        }
    }
    
    var count: Int {
        return readWriteLock.concurrentlyRead {
            nameToPersonMap.count
        }
    }
}

// A ReaderWriterLock implemented using GCD concurrent queue and barriers.

public class ReaderWriterLock {
    private let queue = DispatchQueue(label: "com.domain.app.rwLock", attributes: .concurrent)
    
    public func concurrentlyRead<T>(_ block: (() throws -> T)) rethrows -> T {
        return try queue.sync {
            try block()
        }
    }
    
    public func exclusivelyWrite(_ block: @escaping (() -> Void)) {
        queue.async(flags: .barrier) {
            block()
        }
    }
}


for _ in 0 ..< 5 {
    let iterations = 1000
    let phoneBook = PhoneBook(.threadSafe)
    
    let concurrentTestQueue = DispatchQueue(label: "com.PhoneBookTest.Queue", attributes: .concurrent)
    for _ in 0..<iterations {
        let person = Person.uniquePerson()
        concurrentTestQueue.async {
            phoneBook.addPerson(person)
        }
    }
    
    concurrentTestQueue.async(flags: .barrier) {
        print(phoneBook.count)
    }
}
