//
//  FirebaseService.swift
//  TicTacToe
//
//  Created by Victor Ordozgoite on 09/11/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

final class FirebaseService: ObservableObject {
    static let shared = FirebaseService()
    
    @Published var game: Game!
    
    init() { }
    
    func createOnlineGame() {
        do {
            try FirebaseReference(.Game).document(self.game.id).setData(from: self.game)
        } catch {
            print("Error trying to create online game: \(error.localizedDescription)")
        }
    }
    
    func startGame(with userId: String) {
        FirebaseReference(.Game).whereField("player2Id", isEqualTo: "").whereField("player1Id", isNotEqualTo: userId).getDocuments { querySnapshot, error in
            if error != nil {
                print("An error happened while trying to start the game: \(error?.localizedDescription)")
                self.createNewGame(with: userId)
                return
            }
            
            if let gameData = querySnapshot?.documents.first {
                self.game = try? gameData.data(as: Game.self)
                self.game.player2Id = userId
                self.game.playerIdThatCantMoveNow = userId
                
                self.updateTheGame(self.game)
                self.listenForGameChanges()
            } else {
                self.createNewGame(with: userId)
            }
        }
    }
    
    func listenForGameChanges() {
        FirebaseReference(.Game).document(self.game.id).addSnapshotListener { documentSnapshot, error in
            print("Changes received from Firebase")
            
            if error != nil {
                print("Error listening to changes in Firebase: \(error?.localizedDescription)")
                return
            }
            
            if let snapshot = documentSnapshot {
                self.game = try? snapshot.data(as: Game.self)
            }
        }
    }
    
    func createNewGame(with userId: String) {
        print("Creating new game to user: \(userId)...")
        
        game = Game(id: UUID().uuidString, player1Id: userId, player2Id: "", playerIdThatCantMoveNow: userId, winningPlayerId: "", rematchPlayerId: [], moves: Array(repeating: nil, count: 9))
        createOnlineGame()
        listenForGameChanges()
    }
    
    func updateTheGame(_ game: Game) {
        do {
            try FirebaseReference(.Game).document(game.id).setData(from: game)
        } catch {
            print("Error trying to create online game: \(error.localizedDescription)")
        }
    }
    
    func quitTheGame() {
        guard game != nil else { return }
        FirebaseReference(.Game).document(self.game.id).delete()
    }
}

