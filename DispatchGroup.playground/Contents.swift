
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/* *** */

// just some syntactic sugar

func times(_ times: Int, _ execute: (_ iteration: Int) -> Void) {
    for iteration in 0..<times {
        execute(iteration)
    }
}

let globalQ = DispatchQueue.global()
let group = DispatchGroup()



/* 1 */

/* 'work' will be executed after 'group.wait()' */
let work: () -> Void = {
    sleep(2)
    print("   work executed after 'group.wait()'\n")
}

times(5, { i in
    globalQ.async(group: group) {
        sleep( UInt32(i) )
        print("   async group execution on global (default) queue, iteration: \(i + 1)")
    }
})

print("1: WAIT")

group.notify(queue: globalQ) {
    print("   notify done on global queue\n")
}
group.wait()

work()

/* 2 */

print("3: WAIT")
group.notify(queue: .main) {
    print("   notify done on main queue.\n")
}

times(5, {
    group.enter()
    
    sleep( UInt32($0) )
    print("   async group execution on main queue, iteration: \($0 + 1)")
    
    group.leave()
})

