//
//  BarrierViewController.swift
//  Di
//
//  Created by Apple on 22/11/22.
//

import UIKit

class BarrierViewController: UIViewController {

    let concurrentQueue = DispatchQueue(label: "com.db.categories", attributes: .concurrent)
        var _arr = [1,2,3,4,5,6] // Shared resourse
        private(set) var arr: [Int] {
            get {
                concurrentQueue.sync { self._arr }
            }
            set {
                //2
                concurrentQueue.async(flags: .barrier) {
                    self._arr = newValue
                }
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
