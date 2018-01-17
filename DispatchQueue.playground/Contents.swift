
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
    print(" 1: async code execution on main queue")
}

queueGlobalDefault.sync {
    print(" 2: sync code execution on main queue")
}

queueGlobalBackground.async {
    print(" 3: async time consuming background work is done.")
    
    queueMain.async {
        print(" 4: async UI update on main queue.")
    }
}



/* execute on queue after a delay */
let deadline = DispatchTime.now() + .seconds(2)
queueGlobalDefault.asyncAfter(deadline: deadline) {
    print(" 5: async code execution on main queue, after 2 seconds.")
}

sleep(1)



/* multiple concurrent calls */
let count: Int = 20

queueConcurrent.async {
    DispatchQueue.concurrentPerform(iterations: count) { iteration in
        sleep(1)
        print(" 6: concurrent code execution, iteration \(iteration + 1)")
    }
}
// set barrier to wait till concurrent execution is finished
queueConcurrent.async(flags: .barrier) {
    print(" 7: \(count) concurrent tasks completed.")
}

sleep(5)



/* inactive queue */
let attributes: DispatchQueue.Attributes = [.concurrent, .initiallyInactive]
let inactiveQueue = DispatchQueue(label: "com.com.zayatsoleh.queue.inactive", attributes: attributes)

inactiveQueue.async {
    print(" 8: async code execution on activated queue")
}

print(" 9: ...activate the queue ?")

inactiveQueue.activate()
print("10: work after 'inactiveQueue' activation")


