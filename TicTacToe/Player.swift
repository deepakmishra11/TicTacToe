//
//  Player.swift
//  TicTacToe
//
//  Created by Deepak Mishra on 4/3/17.
//  Copyright © 2017 Deepak Mishra. All rights reserved.
//

import UIKit

enum Player: Int {
    case Human
    case Mobile
    
    var image: UIImage {
        if self == .Human {
            return UIImage(named: "X")!
        }
        return UIImage(named: "O")!
    }
    
    func winningMessage(completion: (String, Player) -> ()) {
        if self == .Human {
            completion("OMG, Human won. Please reset", .Human)
        }else {
            completion("Your Mobile won. Please reset", .Mobile)
        }
    }
    
    func opponent() -> Player {
        switch self {
        case .Human:
            return .Mobile
        case .Mobile:
            return .Human
        }
    }
    
    func callOpponentToMove() -> String {
        if self == .Human {
            //now it's mobile's turn to play
            return "Your Mobile is thinking..."
        }
        //now it's your turn to play
        return "Your turn, Mr. Human"
    }
    
    func checkForTheNextPossibleWinningMove(allOccupiedTiles tilesOccupied: [Int: Player]) -> Int? {
        var tileToChoose: Int?
        
        for winningSet in allWinningSets.shuffled() {
            if (tilesOccupied[winningSet[0]] == self && tilesOccupied[winningSet[1]] == self) {
                if let _ = tilesOccupied[winningSet[2]] {
                    continue
                }
                tileToChoose = winningSet[2]
                break
            }else if tilesOccupied[winningSet[1]] == self && tilesOccupied[winningSet[2]] == self {
                if let _ = tilesOccupied[winningSet[0]] {
                    continue
                }
                tileToChoose = winningSet[0]
                break
            }else if tilesOccupied[winningSet[0]] == self && tilesOccupied[winningSet[2]] == self {
                if let _ = tilesOccupied[winningSet[1]] {
                    continue
                }
                tileToChoose = winningSet[1]
                break
            }
        }
        return tileToChoose
    }
    
    func chooseWinningMove(allOccupiedTiles tilesOccupied: [Int: Player]) -> Int? {
        
        var tileToChoose: Int?
        
        for winningSet in allWinningSets.shuffled() {
            if tilesOccupied[winningSet[0]] == self {
                if tilesOccupied[winningSet[2]] == nil {
                    tileToChoose = winningSet[2]
                }else if tilesOccupied[winningSet[1]] == nil {
                    tileToChoose = winningSet[1]
                }else {
                    continue
                }
                break
            }else if tilesOccupied[winningSet[1]] == self {
                if tilesOccupied[winningSet[2]] == nil {
                    tileToChoose = winningSet[2]
                }else if tilesOccupied[winningSet[0]] == nil {
                    tileToChoose = winningSet[0]
                }else {
                    continue
                }
                break
            }else if tilesOccupied[winningSet[2]] == self {
                if tilesOccupied[winningSet[0]] == nil {
                    tileToChoose = winningSet[0]
                }else if tilesOccupied[winningSet[1]] == nil {
                    tileToChoose = winningSet[1]
                }else {
                    continue
                }
                break
            }
        }
        
        //first time choosing, then choose any unoccupied tile
        if tileToChoose == nil {
            for winningSet in allWinningSets.shuffled() {
                if tilesOccupied[winningSet[0]] == nil {
                    tileToChoose = winningSet[0]
                    break
                }else if tilesOccupied[winningSet[1]] == nil {
                    tileToChoose = winningSet[1]
                    break
                }else if tilesOccupied[winningSet[2]] == nil {
                    tileToChoose = winningSet[2]
                    break
                }
            }
        }
        return tileToChoose
    }
}
