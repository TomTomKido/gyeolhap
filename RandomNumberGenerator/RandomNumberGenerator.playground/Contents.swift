import UIKit



func nineRandomNumberFrom0To26() -> Array<Int> {
    let sequence = 0 ..< 27
    let shuffledSequence = sequence.shuffled()
    return Array(shuffledSequence[0...8])
}
 
for _ in 1...100 {
    print("realm.add(StageRealm(\(nineRandomNumberFrom0To26())))")
}


