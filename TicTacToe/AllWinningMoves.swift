//
//  AllWinningMoves.swift
//  TicTacToe
//
//  Created by Deepak Mishra on 4/3/17.
//  Copyright © 2017 Deepak Mishra. All rights reserved.
//

import Foundation

let topRowWinningSet = [1, 2, 3]
let middleRowWinningSet = [4, 5, 6]
let bottomRowWinningSet = [7, 8, 9]
let firstColumnWinningSet = [1, 4, 7]
let secondColumnWinningSet = [2, 5, 8]
let thirdColumnWinningSet = [3, 6, 9]
let firstAcrossWinningSet = [1, 5, 9]
let secondAcrossWinningSet = [3, 5, 7]

let allWinningSets = [topRowWinningSet, middleRowWinningSet, bottomRowWinningSet,
                      firstColumnWinningSet, secondColumnWinningSet, thirdColumnWinningSet,
                      firstAcrossWinningSet, secondAcrossWinningSet]




//Below code is to shuffle the winning set array everytime we iterate it
extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
