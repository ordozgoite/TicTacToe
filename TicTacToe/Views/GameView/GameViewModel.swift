//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Victor Ordozgoite on 03/11/22.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    @AppStorage("user") private var userData: Data?
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @Published var game = Game(gameId: UUID().uuidString, player1Id: "player1", player2Id: "player2", playerIdThatCantMoveNow: "player2", winningPlayerId: "", rematchPlayerId: [], moves: Array(repeating: nil, count: 9))
    
    @Published var currentUser: User!
    
    var isPlayer1Turn = true
    
    private let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    
    //MARK: - Init Method
    
    init() {
        getUser()
        
        if currentUser == nil {
            setUser()
        }
        
        print("We have a user with id: \(currentUser.id)")
    }
    
    //MARK: - Move Methods
    
    func getPlayerMove(forIndex index: Int) {
        if isSquareOccupied(in: game.moves, forIndex: index) { return }
        
        game.moves[index] = Move(isPlayer1Moving: isPlayer1Turn, boardIndex: index)
        
        isPlayer1Turn.toggle()
        
        // block the move
        
        if checkForWinCondition(forPlayer1: true, in: game.moves) {
            print("You have won!")
            return
        }
        
        if didTheGameDraw(in: game.moves) {
            print("Draw!")
            return
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        if let _ = moves[index] {
            return true
        } else {
            return false
        }
    }
    
    func checkForWinCondition(forPlayer1 isPlayer1: Bool, in moves: [Move?]) -> Bool {
        let playerMoves = moves.compactMap { $0 }.filter{ $0.isPlayer1Moving == isPlayer1 }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func didTheGameDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    //MARK: - User Methods
    
    func setUser() {
        currentUser = User()
        do {
            print("Encoding user...")
            let data = try JSONEncoder().encode(currentUser)
            userData = data
        } catch {
            print("Error trying to save user.")
        }
    }
    
    func getUser() {
        guard let userData = userData else { return }
        
        do {
            print("Decoding user...")
            currentUser = try JSONDecoder().decode(User.self, from: userData)
        } catch {
            print("Error trying to retrieve user.")
        }
    }
}
