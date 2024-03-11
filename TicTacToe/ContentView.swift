//
//  ContentView.swift
//  TicTacToe
//
//  Created by Daniel Truong on 3/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var boardSize = [3,4,5]
    @State private var selectedBoardSize = 3
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundColorView(topColor: .primaryBlack, bottomColor: .primaryBlack)
                VStack {
                    heroView()
                        Text("Choose Board Size")    .font(.system(size: 24, design: .default))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                            .padding(.top, 24)
                        HStack {
                            BoardSizeView(boardSize: $boardSize, selectedBoardSize: $selectedBoardSize)
                        }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
