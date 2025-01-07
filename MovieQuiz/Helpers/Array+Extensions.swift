import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
//        return indices.contains(index) ? self[index] : nil
    }
}
