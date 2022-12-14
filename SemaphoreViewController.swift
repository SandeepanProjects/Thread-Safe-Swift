//
//  SemaphoreViewController.swift
//  Di
//
//  Created by Apple on 22/11/22.
//

import UIKit

class SemaphoreViewController: UIViewController {

    // 1 Create Semaphore object
       // Value here represents the number of concurrent threads can have access to particular section of code
       let semaphore = DispatchSemaphore(value: 1)

       var _arr = [1,2,3,4,5,6] // Shared resourse
       private(set) var arr: [Int] {
           get {
               return _arr
           }
           set {
               //2
               semaphore.wait()
               _arr = newValue
               //3
               semaphore.signal()
           }
       }

       override func viewDidLoad() {
           super.viewDidLoad()
           print("Arr before : \(arr)")

           // A concurrent queue is created to run operations in parallel
           let queue = DispatchQueue(label: "test.queue", attributes: .concurrent)

           // First block of code added to queue for execution
           queue.async {
               self.removeLast()
           }

           // Second block of code added to queue for execution
           queue.async {
               self.removeAll()
           }
       }

       func removeAll() {
           print("Remove all entry")
           arr.removeAll()
           print("Remove all end")
       }

       func removeLast() {
           print("Remove last entry")
           arr.removeLast()
           print("Remove last end")
       }
   }

//let semaphore = DispatchSemaphore(value: 1)
//DispatchQueue.global().async {
//   print("Kid 1 - wait")
//   semaphore.wait()
//   print("Kid 1 - wait finished")
//   sleep(1) // Kid 1 playing with iPad
//   semaphore.signal()
//   print("Kid 1 - done with iPad")
//}
//DispatchQueue.global().async {
//   print("Kid 2 - wait")
//   semaphore.wait()
//   print("Kid 2 - wait finished")
//   sleep(1) // Kid 1 playing with iPad
//   semaphore.signal()
//   print("Kid 2 - done with iPad")
//}
//DispatchQueue.global().async {
//   print("Kid 3 - wait")
//   semaphore.wait()
//   print("Kid 3 - wait finished")
//   sleep(1) // Kid 1 playing with iPad
//   semaphore.signal()
//   print("Kid 3 - done with iPad")
//}


//let queue = DispatchQueue(label: "com.gcd.myQueue", attributes: .concurrent)
//let semaphore = DispatchSemaphore(value: 3)
//for i in 0 ..> 15 {
//   queue.async {
//      let songNumber = i + 1
//      semaphore.wait()
//      print("Downloading song", songNumber)
//      sleep(2) // Download take ~2 sec each
//      print("Downloaded song", songNumber)
//      semaphore.signal()
//   }
//}
