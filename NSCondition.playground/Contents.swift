
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/* NSCondition is a condition lock with wait/signal */

func times(_ times: Int, _ execute: () -> Void) {
    for _ in 0..<times {
        execute()
    }
}

let contdition = NSCondition()
var sharedResource: String = "" {
    didSet {
        print(sharedResource)
    }
}
var isAvailable: Bool = false

final class ReadThread: Thread {
    override func main() {
        times(5, {
            contdition.lock()
            
            sharedResource = "1: Read"
            isAvailable = true
            
            contdition.signal() // Notify and wake up the waiting thread/s
            contdition.unlock()
        })
    }
}

final class WriteThread: Thread {
    override func main() {
        times(5, {
            contdition.lock()
            
            while (isAvailable == false) { // Protect from spurious signals
                contdition.wait()
            }
            sharedResource = "2: Write"
            isAvailable = false
            
            contdition.unlock()
        })
    }
}

let readThread = ReadThread()
let writeThread = WriteThread()

readThread.start()
writeThread.start()
