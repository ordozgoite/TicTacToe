//
//  User.swift
//  TicTacToe
//
//  Created by Victor Ordozgoite on 04/11/22.
//

import Foundation

struct User: Codable {
    var id = UUID().uuidString
    var isPlayer1: Bool?
}
