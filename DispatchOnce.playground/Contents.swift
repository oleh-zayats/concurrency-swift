
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// Some work that needs to be done

let workOne: () -> Void = { print("code has been executed only once (1)") }
let workTwo: () -> Void = { print("code has been executed only once (2)") }

// atomic initialization property of variables
func executeOnce() {
    struct Once {
        static let run: () = {
            workOne()
        }()
    }
    Once.run
}

executeOnce()
executeOnce()
executeOnce()
executeOnce()

// extending DispatchQueue
extension DispatchQueue {
    class func once(token: Int, closure: () -> Void) {
        syncronize {
            if _onceTokens.contains(token) {
                return
            } else {
                _onceTokens.append(token)
            }
            closure()
        }
    }
    
    private static var _onceTokens = [Int]()
    private static var _queue = DispatchQueue(label: "com.zayatsoleh.dispatchqueue.once")
    
    private class func syncronize(_ closure: () -> Void) {
        _queue.sync {
            closure()
        }
    }
}

// some syntactic sugar
func once(token: Int, _ closure: () -> Void) {
    DispatchQueue.once(token: token) { closure() }
}

let token = 1

once(token: token, { workTwo() })
once(token: token, { workTwo() })
once(token: token, { workTwo() })
once(token: token, { workTwo() })
