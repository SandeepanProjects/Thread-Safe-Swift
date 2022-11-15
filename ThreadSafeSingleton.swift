//
//  ThreadSafeSingleton.swift
//  MinCostPath
//
//  Created by sandeepan swain on 15/11/22.
//

import Foundation


class Singleton {

   static let shared = Singleton()

   private init(){}

   private let internalQueue = DispatchQueue(label: "com.singletioninternal.queue",
                                             qos: .default,
                                             attributes: .concurrent)

   private var _foo: String = "aaa"

   var foo: String {
       get {
           return internalQueue.sync {
               _foo
           }
       }
       set (newState) {
           internalQueue.async(flags: .barrier) {
               self._foo = newState
           }
       }
   }

   func setup(string: String) {
       foo = string
   }
}



DispatchQueue.global().async {
    var foo = Singleton.shared.foo // Causes data race
}

DispatchQueue.global().async {
    Singleton.shared.foo = "bar"   // Causes data race
}
