//
//  Model.swift
//  TicTacToe
//
//  Created by Victor Ordozgoite on 03/11/22.
//

import Foundation

struct Move: Codable {
    
    let isPlayer1Moving: Bool
    let boardIndex: Int
    
    var indicator: String {
        return isPlayer1Moving ? "xmark" : "circle"
    }
}

struct Game: Codable {
    let id: String
    var player1Id: String
    var player2Id: String
    
    var playerIdThatCantMoveNow: String
    var winningPlayerId: String
    var rematchPlayerId: [String]
    
    var moves: [Move?]
}
