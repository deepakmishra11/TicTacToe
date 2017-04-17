//
//  ViewController.swift
//  TicTacToe
//
//  Created by Deepak Mishra on 4/3/17.
//  Copyright © 2017 Deepak Mishra. All rights reserved.
//

import UIKit

let TileIsOccupied = "C'mon, that Tile is already selected"
let GameOver = "Looks like no one won. Please reset"

class ViewController: UIViewController {

    @IBOutlet weak var humanScoreLabel: UILabel! {
        didSet {
            humanScoreLabel.text = "0"
        }
    }
    @IBOutlet weak var mobileScoreLabel: UILabel! {
        didSet {
            mobileScoreLabel.text = "0"
        }
    }
    @IBOutlet weak var resetButton: UIButton! {
        didSet {
            //initially make it hidden
            resetButton.isHidden = true
        }
    }
    @IBOutlet var allTiles: [Tile]! 
    
    @IBOutlet weak var statusMessageLabel: UILabel!
    
    // At starting, first player will be Human
    private var player: Player = .Human
    
    // Remember the winner so that in next game we can ask winner to start the game
    private var lastGameWinner: Player = .Human
    
    private var isGameOver: Bool = false
    
    ///remember the selected tiles
    private var tilesOccupied: [Int: Player] = [:]
    
    //boolean to check when mobile is thinking
    private var mobileIsThinking: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //call whenever either player make a move
    @IBAction func playersMove(tile: Tile) {
        if self.isGameOver || self.mobileIsThinking {
            //do not allow user to touch any tile.
            return
        }
        
        //mark the tile with respective Image, otherwise show the relevant message
        weak var weakSelf: ViewController! = self
        tile.chosen(byPlayer: self.player, ifAlreadyChosen: {
            weakSelf.statusMessageLabel.text = TileIsOccupied
        })
        
        if let _ = self.tilesOccupied[tile.tag] {
            //tile is already selected
            return
        }
        
        //remember the selected tiles
        self.tilesOccupied[tile.tag] = self.player
        
        //check if anyone wins
        self.checkIfAnyoneWins()
    }
    
    func checkIfAnyoneWins() {
        var noOneWon = true
        for winningSet in allWinningSets.shuffled() {
            if tilesOccupied[winningSet[0]] == self.player &&
                tilesOccupied[winningSet[1]] == self.player &&
                tilesOccupied[winningSet[2]]  == self.player {
                
                // winner found, show the winning message
                weak var weakSelf: ViewController! = self
                self.player.winningMessage(completion: { (winningMessage, winningPlayer) in
                    weakSelf.statusMessageLabel.text = winningMessage
                    weakSelf.lastGameWinner = winningPlayer
                    switch winningPlayer {
                    case .Human:
                        weakSelf.humanScoreLabel.text = "\(Int(weakSelf.humanScoreLabel.text!)! + 1)"
                    case .Mobile:
                        weakSelf.mobileScoreLabel.text = "\(Int(weakSelf.mobileScoreLabel.text!)! + 1)"
                    }
                })
                self.isGameOver = true
                
                //remember the winner
                self.lastGameWinner = self.player
                noOneWon = false
                
                //show the reset button
                self.resetButton.isHidden = false
                break
            }
            
        }
        if noOneWon && tilesOccupied.count == 9 {
            self.statusMessageLabel.text = GameOver
            self.isGameOver = true
            
            //show the reset button
            self.resetButton.isHidden = false
        }else if noOneWon && tilesOccupied.count < 9 {
            //switch the player
            self.switchThePlayer()
        }
    }
    
    func switchThePlayer() {
        self.statusMessageLabel.text = self.player.callOpponentToMove()
        if self.player == .Human {
            self.player = .Mobile
            
            //set the boolean to not allow any operation while mobile is about to perform its action
            self.mobileIsThinking = true
            
            //delay to show the fake thinking of your mobile
            perform(#selector(mobileWillPlay), with: nil, afterDelay: 2)
        }else {
            self.player = .Human
        }
    }
    
    func mobileWillPlay() {
        
        self.mobileIsThinking = false
        
        //check if you are about to win, then select the winning tile asap
        if let tileWhichMakesYouWin = self.player.checkForTheNextPossibleWinningMove(allOccupiedTiles: tilesOccupied) {
            let tile = self.allTiles.filter({ $0.tag == tileWhichMakesYouWin })[0]
            self.playersMove(tile: tile)
        }
            
        //check if Human is about to win, then stop his/her win asap
        else if let tileWhichMakesHumanWin = self.player.opponent().checkForTheNextPossibleWinningMove(allOccupiedTiles: tilesOccupied) {
            let tile = self.allTiles.filter({ $0.tag == tileWhichMakesHumanWin })[0]
            self.playersMove(tile: tile)
        }
        
        //otherwise choose wisely to make a winnning move
        else if let tileWhichLeadsYouToWin = self.player.chooseWinningMove(allOccupiedTiles: tilesOccupied) {
            let tile = self.allTiles.filter({ $0.tag == tileWhichLeadsYouToWin })[0]
            self.playersMove(tile: tile)
        }
        
        //game over, no valid move left i guess
        else {
            self.statusMessageLabel.text = GameOver
            self.isGameOver = true
            self.resetButton.isHidden = false
        }
    }
    
    
    @IBAction func reset() {
        
        //again hid the resetButton
        self.resetButton.isHidden = true
        
        self.isGameOver = false
        self.mobileIsThinking = false
        self.tilesOccupied.removeAll()
        
        for tile in self.allTiles {
            tile.isSelected = false
            tile.setBackgroundImage(nil, for: .normal)
        }
        
        //while resetting do not reset the last winner
        //last winner will continue the next game
        if self.lastGameWinner == .Human {
            self.statusMessageLabel.text = Player.Mobile.callOpponentToMove()
        }else {
            self.statusMessageLabel.text = Player.Human.callOpponentToMove()
            self.mobileWillPlay()
        }
    }
}
