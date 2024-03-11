//
//  LandingView.swift
//  TicTacToe
//
//  Created by Daniel Truong on 3/10/24.
//

import SwiftUI

struct BackgroundColorView: View {
    var topColor: Color
    var bottomColor: Color
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [topColor, bottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}


struct heroView: View {
    var body: some View {
        Text("TIC TAC TOE")
            .font(.system(size: 32, design: .default))
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .padding(.top, 40)
            .padding(.bottom, 40)
            .foregroundColor(.white)
        Image("landingImage").resizable().aspectRatio(contentMode: .fit)
            .frame(width: 480, height: 480)
    }
}

struct BoardSizeView: View {
    @Binding var boardSize: [Int]
    @Binding var selectedBoardSize: Int
    var body: some View {
                ForEach(boardSize, id: \.self) {
                    size in
                    NavigationLink(destination: GamePlayView(board: Array(repeating: Array(repeating: "", count: selectedBoardSize), count: selectedBoardSize), boardSize: selectedBoardSize)) {
                        Text("\(size)x\(size)")
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .font(.system(size: 28, design: .default))
                            .background(Color.primaryBlue)
                            .cornerRadius(24)
                            .padding(12)
                }.simultaneousGesture(TapGesture().onEnded {
                    selectedBoardSize = size
                })
            }
    }
}
