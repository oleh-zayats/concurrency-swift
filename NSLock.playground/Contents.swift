
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// some syntactic sugar
extension NSLock {
    func synchronized(execute: () -> Void) {
        lock()
        execute()
        unlock()
    }
}

func times(_ times: Int, _ execute: () -> Void) {
    for _ in 0..<times {
        execute()
    }
}

/* testing: */

let lock = NSLock()
var counter = 0

let thread1 = Thread {
    times(10, {
        lock.synchronized {
            counter += 1
            print("Thread 1: counter = \(counter)")
        }
    })
}

let thread2 = Thread {
    times(10, {
        lock.synchronized {
            counter += 1
            print("Thread 2: counter = \(counter)")
        }
    })
}

thread1.start()
thread2.start()

sleep(3)
print("- - -")

// some more syntactic sugar (2)
extension NSLock {
    class func synchronized(_ token: AnyHashable, execute: () -> Void) {
        objc_sync_enter(token)
        execute()
        objc_sync_exit(token)
    }
}

func synchronized(_ token: AnyHashable, execute: () -> Void) {
    NSLock.synchronized(token, execute: execute)
}

/* testing (2): */

let counter2: Int = 0
let token = NSObject()

let thread3 = Thread {
    times(10, {
        NSLock.synchronized(token) {
            counter += 1
            print("Thread 3: counter = \(counter)")
        }
    })
}

let thread4 = Thread {
    times(10, {
        NSLock.synchronized(token) {
            counter += 1
            print("Thread 4: counter = \(counter)")
        }
    })
}

thread3.start()
thread4.start()
