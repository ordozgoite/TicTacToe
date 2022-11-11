//
//  AlertItem.swift
//  TicTacToe
//
//  Created by Victor Ordozgoite on 10/11/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var isForQuit = false
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let youWin = AlertItem(title: Text("You win! 🎉"), message: Text("You are good at this game!"), buttonTitle: Text("Rematch"))
    
    static let youLost = AlertItem(title: Text("You lost! 😬"), message: Text("You are good at this game!"), buttonTitle: Text("Rematch"))
    
    static let draw = AlertItem(title: Text("Draw! 😐"), message: Text("You are good at this game!"), buttonTitle: Text("Rematch"))
    
    static let quit = AlertItem(isForQuit: true, title: Text("Game Over! ❌"), message: Text("The other player has left the game."), buttonTitle: Text("Quit"))
}
