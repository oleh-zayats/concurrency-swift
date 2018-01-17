
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/* Semaphore allows more than one thread to access a shared resource if it is configured accordingly. */

// https://en.wikipedia.org/wiki/Dining_philosophers_problem
// http://greenteapress.com/wp/semaphores/

// just some syntactic sugar
func concurrent(_ times: Int, _ execute: (_ iteration: Int) -> Void) {
    DispatchQueue.concurrentPerform(iterations: times) { (iteration: Int) in
        execute(iteration)
    }
}

/*******/

let globalQ = DispatchQueue.global()
let executeTimeConsumingOperation: () -> Void = { sleep(3) }

// semaphore will be held by groups of two pool threads
let semaphore = DispatchSemaphore(value: 2)

globalQ.sync {
    concurrent(10, { i in
        semaphore.wait(timeout: .distantFuture)
        
        executeTimeConsumingOperation()
        print("\(i) acquired semaphore.")
        
        semaphore.signal()
    })
}
