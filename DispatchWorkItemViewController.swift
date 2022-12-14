//
//  DispatchWorkItemViewController.swift
//  Di
//
//  Created by Apple on 22/11/22.
//

import UIKit

class DispatchWorkItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let dwi = DispatchWorkItem {
            for i in 1...5 {
                print("DispatchWorkItem \(i)")
            }
        }
        // Perform on the current thread
        dwi.perform()
        // Perform on the global queue
        DispatchQueue.global().async(execute: dwi)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//class SearchViewController: UIViewController, UISearchBarDelegate {
//    // We keep track of the pending work item as a property
//    private var pendingRequestWorkItem: DispatchWorkItem?
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // Cancel the currently pending item
//        pendingRequestWorkItem?.cancel()
//
//        // Wrap our request in a work item
//        let requestWorkItem = DispatchWorkItem { [weak self] in
//            self?.resultsLoader.loadResults(forQuery: searchText)
//        }
//
//        // Save the new work item and execute it after 250 ms
//        pendingRequestWorkItem = requestWorkItem
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
//                                      execute: requestWorkItem)
//    }
//}

//struct DispatchStruct {
//    func workItemExample(){
//        var myNumber : Int = 15
//        let workItem = DispatchWorkItem {
//            // Code you need to execute in workitem
//            myNumber += 5
//        }
//        // Create a Queue where you want to exexcute the workitem
//        let queue = DispatchQueue.global(qos: .utility)
//        queue.async(execute: workItem)
//        //Once completed
//        workItem.notify(queue: .main) {
//            print("workitem is completed", myNumber)
//        }
//    }
//}
//let obj = DispatchStruct()
//obj.workItemExample()

//struct DispatchStruct {
//    func cancelWorkItemExample(){
//        var workItem : DispatchWorkItem!
//        workItem = DispatchWorkItem {
//            for i in 0...100 {
//                guard let newWorkItem = workItem, !newWorkItem.isCancelled else {
//                    print("WorkItem is cancelled")
//                    break
//                }
//                print(i)
//                sleep(1)
//            }
//        }
//        //Once completed
//        workItem.notify(queue: .main) {
//            print("workitem is completed")
//        }
//        let queue = DispatchQueue.global(qos: .utility)
//        queue.async(execute: workItem)
//        //cancel the workitem after delay
//        queue.asyncAfter(deadline: .now() + .seconds(3)) {
//            //Do required task asfter 3 seconds
//            workItem.cancel()
//        }
//    }
//}
//let obj = DispatchStruct()
//obj.cancelWorkItemExample()
