//: [Previous](@previous)

import Foundation

// Swift's standard library use copy-pn-write to provide value semantics

// 1.Data struct VS NSMutableData class
var smapleBytes: [UInt8] = [0x0B, 0xAD, 0xF0, 0x0D]
let nsData = NSMutableData(bytes: smapleBytes, length: smapleBytes.count) // reference type mutablilty not controlled via let/var

let nsOtherData = nsData // refernce to nsData
let nsDataCopy = nsData.mutableCopy() as! NSMutableData

nsData.append(smapleBytes, length: smapleBytes.count)
nsData.isEqual(nsOtherData)
nsData.isEqual(nsDataCopy)

var data = Data(bytes: smapleBytes, count: smapleBytes.count)

let dataCopy = data
data.append(smapleBytes, count: smapleBytes.count)
dataCopy.elementsEqual(data)

// ⚠️ Data hase an internal refernce to memory,begining of copy only refernce is copied to new value, acutal data is copied when make changes like append or update ...

/// Implement of copy-on-write

final class Box<A> {
    let unbox: A
    init(_ value: A) {
        unbox = value
    }
}

struct MyData {
    var data = Box(NSMutableData())
    var dataForWritting: NSMutableData {
        mutating get { // get is mutating getter
            // Warning: this is not correct yet! isKnownUniauelyReferenced only work for swift objec
            if isKnownUniquelyReferenced(&data) { // only work with swift object
                return data.unbox
            }
            print("making a copy")
            data = Box(data.unbox.mutableCopy() as! NSMutableData)
            return data.unbox
        }
    }

    mutating func append(bytes: [UInt8], count: Int) {
        dataForWritting.append(bytes, length: bytes.count)
    }
}

extension MyData: CustomDebugStringConvertible {
    var debugDescription: String {
        return String(describing: data)
    }
}

var mydata = MyData()
// can see info on playground
let copy = mydata

print("Befor Loop")
for _ in 0 ..< 10 {
    mydata.append(bytes: smapleBytes, count: smapleBytes.count)
}

// not good for reduce
(0 ..< 10).reduce(mydata) { result, _ in
    var copy = result
    copy.append(bytes: smapleBytes, count: smapleBytes.count)
    return copy
}

//: [Next](@next)
