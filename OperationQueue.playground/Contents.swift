
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/* OperationQueue, Operation */

var queue = OperationQueue()
queue.name = ".com.zayats.oleh.operation.queue"
queue.maxConcurrentOperationCount = 2

final class OperationOne: Operation {
    override func main() {
        sleep(2)
        print("1: starting operation 1 execution")
    }
}

final class OperationTwo: Operation {
    override func main() {
        sleep(2)
        print("2: starting operation 2 execution")
    }
}

let operation1 = OperationOne()
let operation2 = OperationTwo()

queue.addOperation(operation1)
queue.addOperation(operation2)


/* Block Operations */

let operation3 = BlockOperation {
    sleep(2)
    print("3: starting operation 3 execution")
}

operation3.queuePriority = .veryHigh
operation3.completionBlock = {
    if operation3.isCancelled {
        print("3: cancelled operation 3")
    }
    print("3: block operation has been executed")
}

// Refers to the queue of the main thread
let mainQ = OperationQueue.main

let operation4 = BlockOperation {
    print("4: 4-th operation always goes after 3-rd")
    mainQ.addOperation {
        print("4: block operation has been executed (main queue)")
    }
}

/* Dependency */

operation4.addDependency(operation3)

queue.addOperation(operation4)  // op3 will complete before op4, always
queue.addOperation(operation3)

/* Status */

operation3.isReady       // Ready for execution?
operation3.isExecuting   // Executing now?
operation3.isFinished    // Finished naturally or cancelled?
operation3.isCancelled   // Manually cancelled?
