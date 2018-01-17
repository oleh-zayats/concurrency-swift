
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/* *** */

let globalQ = DispatchQueue.global()

let workItem = DispatchWorkItem {
    print("code has been executed")
}

workItem.perform()

workItem.notify(queue: .main) {
    print("notified on main queue")
}

globalQ.async(execute: workItem)

// item.cancel()
// item.wait()
