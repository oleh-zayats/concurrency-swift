
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/*******/

class Parameters: NSObject {
    let parameter1: String
    let parameter2: String
    
    init(parameter1: String, parameter2: String) {
        self.parameter1 = parameter1
        self.parameter2 = parameter2
    }
}

class Handler: NSObject {
    @objc func execute(with parameters: Parameters) {
        print("0: executed with params: \(parameters.parameter1) & \(parameters.parameter2)\n")
    }
}

let handler = Handler()
let parameters = Parameters(parameter1: "001", parameter2: "002")

let threadOne = Thread(target: handler, selector: #selector(Handler.execute(with:)), object: parameters)
threadOne.start()

/*******/

let sleepInterval: TimeInterval = 3

/* Creating thread by subclassing Thread */

final class CustomThread: Thread {
    override func main() {
        print("1: start thread, sleep for \(sleepInterval) seconds")
        Thread.sleep(forTimeInterval: sleepInterval)
        print("2: wake up, exit thread")
    }
}

let threadTwo = CustomThread()
threadTwo.stackSize = 1024 * 16
threadTwo.start()


sleep(UInt32(sleepInterval + 1))
print("\n")

/* or via closure */

let threadThree = CustomThread {
    print("1: start thread, sleep for \(sleepInterval) seconds")
    Thread.sleep(forTimeInterval: sleepInterval)
    print("2: wake up, exit thread")
}

threadThree.stackSize = 1024 * 16
threadThree.start()





