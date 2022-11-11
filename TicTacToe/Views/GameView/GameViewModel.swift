//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Victor Ordozgoite on 03/11/22.
//

import SwiftUI
import Combine

final class GameViewModel: ObservableObject {
    
    @AppStorage("user") private var userData: Data?
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @Published var game: Game? {
        didSet {
            checkIfGameIsOver()
            
            if game == nil {
                updateGameNotificationFor(.finished)
            } else {
                game?.player2Id == "" ? updateGameNotificationFor(.waitingForPlayer) : updateGameNotificationFor(.started)
            }
        }
    }
    
    @Published var gameNotification = GameNotification.waitingForPlayer
    @Published var currentUser: User!
    @Published var alertItem: AlertItem?
    
    private var cancellables: Set<AnyCancellable> = []
    
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
        guard game != nil else { return }
        
        if isSquareOccupied(in: game!.moves, forIndex: index) { return }

        game!.moves[index] = Move(isPlayer1Moving: isPlayer1(), boardIndex: index)
        game!.playerIdThatCantMoveNow = currentUser.id
        
        FirebaseService.shared.updateTheGame(game!)

        // block the move

        if checkForWinCondition(forPlayer1: isPlayer1(), in: game!.moves) {
            print("You have won!")
            game!.winningPlayerId = currentUser.id
            FirebaseService.shared.updateTheGame(game!)
            return
        }

        if didTheGameDraw(in: game!.moves) {
            print("Draw!")
            game!.winningPlayerId = "0"
            FirebaseService.shared.updateTheGame(game!)
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
    
    func checkForGameBoardStatus() -> Bool {
        return game != nil ? game!.playerIdThatCantMoveNow == currentUser.id : false
    }
    
    func isPlayer1() -> Bool {
        return game != nil ? game!.player1Id == currentUser.id : false
    }
    
    func checkIfGameIsOver() {
        guard game != nil else { return }
        
        if game!.winningPlayerId == "0" {
            alertItem = AlertContext.draw
        } else if game!.winningPlayerId != "" {
            if game!.winningPlayerId == currentUser.id {
                alertItem = AlertContext.youWin
            } else {
                alertItem = AlertContext.youLost
            }
        }
    }
    
    func resetTheGame() {
        guard game != nil else {
            alertItem = AlertContext.quit
            return
        }
        
        if game!.rematchPlayerId.count == 1 {
            // start new game
            game!.moves = Array(repeating: nil, count: 9)
            game!.winningPlayerId = ""
            game!.playerIdThatCantMoveNow = game!.player2Id
        } else if game!.rematchPlayerId.count == 2 {
            game!.rematchPlayerId = []
        }
        
        game!.rematchPlayerId.append(currentUser.id)
        
        FirebaseService.shared.updateTheGame(game!)
    }
    
    func updateGameNotificationFor(_ state: GameState) {
        switch state {
        case .started:
            gameNotification = GameNotification.gameHasStarted
        case .waitingForPlayer:
            gameNotification = GameNotification.waitingForPlayer
        case .finished:
            gameNotification = GameNotification.gameFinished
        }
    }
    
    func getTheGame() {
        FirebaseService.shared.startGame(with: currentUser.id)
        FirebaseService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
    }
    
    func quitTheGame() {
        FirebaseService.shared.quitTheGame()
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
