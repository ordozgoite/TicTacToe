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
            Text(viewModel.gameNotification)
            
            Button {
                mode.wrappedValue.dismiss()
                viewModel.quitTheGame()
            } label: {
                GameButton(title: "Quit", backgroundColor: .red)
            }
            
            if viewModel.game?.player2Id == "" {
                LoadingView()
            }
            
            Spacer()
            
            VStack {
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0 ..< 9) { i in
                        ZStack {
                            GameSquareView()
                            
                            PlayerIndicatorView(systemImageName: viewModel.game?.moves[i]?.indicator ?? "applelogo")
                        }
                        .onTapGesture {
                            viewModel.getPlayerMove(forIndex: i)
                        }
                    }
                }
            }
            .disabled(viewModel.checkForGameBoardStatus())
            .padding(.horizontal)
            .alert(item: $viewModel.alertItem) { alertItem in
                alertItem.isForQuit ? Alert(title: alertItem.title, message: alertItem.message, dismissButton: .destructive(alertItem.buttonTitle, action: {
                    self.mode.wrappedValue.dismiss()
                    viewModel.quitTheGame()
                }))
                : Alert(title: alertItem.title, message: alertItem.message, primaryButton: .default(alertItem.buttonTitle, action: {
                    viewModel.resetTheGame()
                }), secondaryButton: .destructive(Text("Quit"), action: {
                    self.mode.wrappedValue.dismiss()
                    viewModel.quitTheGame()
                }))
            }
        }.onAppear {
            viewModel.getTheGame()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel())
    }
}
