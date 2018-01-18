
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/* NSRecursiveLock can be acquired multiple times by the same thread without blocking. */

extension NSRecursiveLock {
    func lockedRecursively(execute: () -> Void) {
        lock()
        execute()
        unlock()
    }
}

let lock = NSRecursiveLock()

class RecThread: Thread {
    override func main() {
        lock.lockedRecursively {
            print("thread locked from main")
            execute()
        }
        print("exit main")
    }
    
    func execute() {
        lock.lockedRecursively {
            print("thread locked from 'execute'")
        }
        print("exit 'execute'")
    }
}

let thread = RecThread()
thread.start()

sleep(3)
print("- - -")

/*******/

class Storage {
    private let lock = NSRecursiveLock()
    var value: String = "." {
        willSet(value) {
            print("locked \(value)")
            lock.lock()
            
        } didSet {
            lock.unlock()
            print("unlock \(value)")
        }
    }
}

class Client {
    private let q1 = DispatchQueue(label: "com.zayats.oleh.sync.access.0", attributes: .concurrent)
    private let q2 = DispatchQueue(label: "com.zayats.oleh.sync.access.1", attributes: .concurrent)
    
    let storage = Storage()
    
    func mutate() {
        q1.async {
            self.storage.value = "0"
        }
        q1.async {
            self.storage.value = "1"
        }
        q1.async {
            self.storage.value = "2"
        }
        q1.async {
            self.storage.value = "3"
        }
        
        q2.async {
            self.storage.value = "4"
        }
        q2.async {
            self.storage.value = "5"
        }
        q2.async {
            self.storage.value = "6"
        }
        q2.async {
            self.storage.value = "7"
        }
    }
}

let client = Client()
client.mutate()
