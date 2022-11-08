//
//  GameView.swift
//  TicTacToe
//
//  Created by Victor Ordozgoite on 03/11/22.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text("Waiting for another player.")
            
            Button {
                mode.wrappedValue.dismiss()
            } label: {
                GameButton(title: "Quit", backgroundColor: .red)
            }
            
            LoadingView()
            
            Spacer()
            
            VStack {
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0 ..< 9) { i in
                        ZStack {
                            GameSquareView()
                            
                            PlayerIndicatorView(systemImageName: viewModel.game.moves[i]?.indicator ?? "applelogo")
                        }
                        .onTapGesture {
                            viewModel.getPlayerMove(forIndex: i)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel())
    }
}
