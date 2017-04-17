//
//  Tile.swift
//  TicTacToe
//
//  Created by Deepak Mishra on 4/3/17.
//  Copyright © 2017 Deepak Mishra. All rights reserved.
//

import UIKit

class Tile: UIButton {
    func chosen(byPlayer player: Player, ifAlreadyChosen: () -> ()) {
        if self.isSelected {
            ifAlreadyChosen()
            return
        }
        self.isSelected = true
//        self.setImage(player.image, for: .normal)
        self.setBackgroundImage(player.image, for: .normal)
    }
}
