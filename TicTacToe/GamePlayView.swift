//
//  GamePlayView.swift
//  TicTacToe
//
//  Created by Daniel Truong on 3/10/24.
//

import SwiftUI
import Observation

@Observable
class Player {
    var id: Int
    var isTurn: Bool = false
    var hasWon: Bool = false
    var wins: Int = 0
    var symbol: String = ""
    init(id:Int, isTurn: Bool, symbol: String) {
        self.id = id
        self.isTurn = isTurn
        self.symbol = symbol
    }
}

struct GamePlayView: View {
  @State var board: [[String]]
  let boardSize: Int
    @State var filledTiles: Int = 0
    @State var rowsArray: [Int]
    @State var colsArray: [Int]
    @State var diag: Int = 0
    @State var antiDiag: Int = 0
    @State var player1 = Player(id:1, isTurn: true, symbol: "X")
    @State var player2 = Player(id:2, isTurn: false, symbol: "O")
    @State private var showWinnerAlert = false
    @State private var winningCells: [(row: Int, column: Int)] = []
    init(board: [[String]], boardSize: Int) {
        self.board = board
        self.boardSize = boardSize
        _rowsArray = State(initialValue: Array(repeating: 0, count: boardSize))
        _colsArray = State(initialValue: Array(repeating: 0, count: boardSize))
    }
  var body: some View {
      let columns: [GridItem] = Array(repeating: .init(.flexible()), count: boardSize)
      ZStack {
          BackgroundColorView(topColor: .primaryBlack, bottomColor: .primaryBlue)
          VStack {
              let currentSymbol: String =  player1.isTurn ? player1.symbol : player2.symbol
              Text("\(player1.isTurn ? "Player 1's" : "Player 2's") (\(currentSymbol)) turn")
                  .font(.title).foregroundColor(.white).padding(.bottom, 24)
              LazyVGrid(columns: columns, spacing: 20) {
                  ForEach(0..<boardSize, id: \.self) { row in
                      ForEach(0..<boardSize, id: \.self) { column in
                          Button(action: {
                              if board[row][column].isEmpty {
                                  filledTiles += 1
                                  if filledTiles == boardSize * boardSize {
                                      showWinnerAlert = true
                                  }
                                  let currentPlayerId: Int = player1.isTurn ? player1.id : player2.id
                                  board[row][column] = currentSymbol
                                  toggleTurn()
                                  move(row: row, col: column, player: currentPlayerId)
                              } else {
                                  return
                              }
                          }){
                              Text(board[row][column])
                                  .frame(width: 60, height: 60)
                                  .foregroundColor(.white)
                                  .font(.largeTitle)
                                  .background(self.isWinningCell(row: row, column: column) ? Color.green.opacity(0.7) : .primaryBlack.opacity(0.7))
                                  .cornerRadius(5)
                          }.overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primaryBlue, lineWidth: 2)
                        ).alert(isPresented: $showWinnerAlert) {
                              Alert(
                                  title: Text("Game Over"),
                                  message: Text(player1.hasWon ? "The winner is Player 1, WINS: \(player1.wins)" : player2.hasWon ? "The winner is Player 2, WINS: \(player2.wins)" : "It's a tie"),
                                  dismissButton: .default(Text("OK")) {
                                      newGame()
                                  }
                              )
                          }
                      }
                  }
              }
          }
      }
  }
    func toggleTurn() {
        player1.isTurn.toggle()
        player2.isTurn.toggle()
    }
    
    func move(row: Int, col: Int, player: Int) -> Int {
        let toAdd: Int = player == 1 ? 1 : -1
        rowsArray[row] += toAdd
        colsArray[col] += toAdd
        if (row == col) {
            diag += toAdd
        }
        if (col + row == colsArray.count - 1) {
            antiDiag += toAdd
        }
        let size = rowsArray.count
        // Winning condition
        if (abs(rowsArray[row]) == size) {
            // Row win
            winningCells = (0..<size).map { (row, $0) }
        } else if (abs(colsArray[col]) == size) {
            // Column win
            winningCells = (0..<size).map { ($0, col) }
        } else if (abs(diag) == size) {
            // Diagonal win
            winningCells = (0..<size).map { ($0, $0) }
        } else if (abs(antiDiag) == size) {
            // Anti-diagonal win
            winningCells = (0..<size).map { ($0, size - 1 - $0) }
        }
        // Determine winner
        if !winningCells.isEmpty {
            if (player == 1) {
                win(player: player1)
            } else {
                win(player: player2)
            }
            return player
        }
        return 0
    }
    
    func win(player: Player) {
        player.hasWon = true
        player.wins += 1
        showWinnerAlert = true
    }
    
    func isWinningCell(row: Int, column: Int) -> Bool {
        // Check if the current cell is part of the winning combination
        return winningCells.contains { $0.row == row && $0.column == column }
    }
    
    func newGame() {
        board = Array(repeating: Array(repeating: "", count: boardSize), count: boardSize)
        filledTiles = 0
        winningCells = []
        rowsArray = Array(repeating: 0, count: boardSize)
        colsArray = Array(repeating: 0, count: boardSize)
        diag = 0
        antiDiag = 0
        player1.isTurn = true
        player1.hasWon = false
        player2.isTurn = false
        player2.hasWon = false
    }
}

#Preview {
    GamePlayView(board: Array(repeating: Array(repeating: "", count: 3), count: 3), boardSize: 3)
}
