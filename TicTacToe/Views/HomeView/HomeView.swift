//
//  ContentView.swift
//  TicTacToe
//
//  Created by Victor Ordozgoite on 03/11/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Button {
                viewModel.isGameViewPresented = true
            } label: {
                GameButton(title: "Play", backgroundColor: .green)
            }
        }
        .fullScreenCover(isPresented: $viewModel.isGameViewPresented) {
            GameView(viewModel: GameViewModel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
