import Foundation

// 1. mutation on struct differs from mutaion on class
// 2. how achieve mutation on struct

var x = [3,1,2]
let y = x
x.sort() // mutating func
x
y

y.sorted()
    .map({$0 * $0})
// not mutation
y
