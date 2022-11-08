//
//  GameSquareView.swift
//  TicTacToe
//
//  Created by Victor Ordozgoite on 03/11/22.
//

import SwiftUI

struct GameSquareView: View {
    var body: some View {
        Circle()
            .foregroundColor(.blue.opacity(0.7))
    }
}

struct GameSquareView_Previews: PreviewProvider {
    static var previews: some View {
        GameSquareView()
    }
}
