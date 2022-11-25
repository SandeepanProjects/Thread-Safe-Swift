//
//  CustomLogger.swift
//  CustomLogger
//
//  Created by Apple on 25/11/22.
//

import UIKit

class Logger {
    static let shared = Logger()
    
    private init(){}
    
    func debugPrint(
        _ message: Any,
        extra1: String = #file,
        extra2: String = #function,
        extra3: Int = #line,
        remoteLog: Bool = false,
        plain: Bool = false
    ) {
        if plain {
            print(message)
        }
        else {
            let filename = (extra1 as NSString).lastPathComponent
            print(message, "[\(filename) \(extra3) line]")
        }
        
        // if remoteLog is true record the log in server
        if remoteLog {
//            if let msg = message as? String {
//                logEvent(msg, event: .error, param: nil)
//            }
        }
    }
    
    /// pretty print
    func prettyPrint(_ message: Any) {
        dump(message)
    }
    
    func printDocumentsDirectory() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("Document Path: \(documentsPath)")
    }
    
    /// Track event to firebse
    func logEvent(_ name: String? = nil, event: String? = nil, param: [String: Any]? = nil) {
       
        // Analytics.logEvent(name, parameters: param)
    }
}

class CustomLogger: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                Logger.shared.debugPrint("Hello World")
                Logger.shared.debugPrint(["a", "b", "c"])
                Logger.shared.debugPrint("Log it in the server", remoteLog: true)
                Logger.shared.prettyPrint(["a", "b", "c"])
                Logger.shared.logEvent("ContentView", event: "First Screen")
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
