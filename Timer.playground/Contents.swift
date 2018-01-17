
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/* Timer */

let interval: TimeInterval = 5

final class Work: NSObject {
    @objc func performAfterDelay(timer: Timer) {
        defer {
            timer.invalidate()
        }
        print("code executed after \(interval) seconds")
        
        let userInfo = timer.userInfo as? [String: String]
        let parameter = userInfo?["parameter"]
        
        if let parameter = parameter {
            print("invoked with parameter: \(parameter)")
        }
    }
}

let target = Work()
let timer: Timer = .scheduledTimer(timeInterval: interval,
                                         target: target,
                                       selector: #selector(Work.performAfterDelay(timer:)),
                                       userInfo: ["parameter": "some_value"],
                                        repeats: false)
