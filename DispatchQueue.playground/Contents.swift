
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/* DispatchQueue manages the execution of work items.
   Each work item submitted to a queue is processed on a pool of threads managed by the system. */


// QoSClass

// default:         The default quality of service class.
// userInteractive: The user-interactive quality of service class.
// userInitiated:   The user-initiated quality of service class.
// utility:         The utility quality of service class.
// background:      The background quality of service class
// unspecified:     The absence of a quality of service class.

let queueSerial = DispatchQueue(label: "com.zayatsoleh.queue.serial")
let queueConcurrent = DispatchQueue(label: "com.zayatsoleh.queue.concurrent", attributes: .concurrent)

let queueMain = DispatchQueue.main
let queueGlobalDefault = DispatchQueue.global()

let queueGlobalBackground = DispatchQueue.global(qos: .background)
let queueSerialHighPriority = DispatchQueue(label: "com.zayatsoleh.queue.serial.priority.high", qos: .userInteractive)

/* Different queue execution */

queueGlobalDefault.async {
    print("async code execution on main queue")
}

queueGlobalDefault.sync {
    print("sync code execution on main queue")
}

queueGlobalBackground.async {
    print("async time consuming background work is done.")
    
    queueMain.async {
        print("async UI update on main queue.")
    }
}

// execute on queue after a delay
let deadline = DispatchTime.now() + .seconds(2)
queueGlobalDefault.asyncAfter(deadline: deadline) {
    print("async code execution on main queue, after 2 seconds.")
}

sleep(1)

// multiple concurrent calls
queueConcurrent.async {
    DispatchQueue.concurrentPerform(iterations: 20) { iteration in
        sleep(1)
        print("concurrent code execution, iteration \(iteration + 1)")
    }
}
// set barrier to wait till concurrent execution is finished
queueConcurrent.async(flags: .barrier) {
    print("All 5 concurrent tasks completed")
}


