//
//  ChessBoardView.swift
//  chess-swift
//
//  Main chess board rendering
//

import SwiftUI

struct ChessBoardView: View {
    @Bindable var gameState: GameState
    let boardSize: CGFloat

    private var squareSize: CGFloat {
        boardSize / 8
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<8, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { col in
                        let position = Position(row: row, col: col)
                        squareView(for: position)
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }

    @ViewBuilder
    private func squareView(for position: Position) -> some View {
        let piece = gameState.board.piece(at: position)
        let isSelected = gameState.selectedPosition == position
        let isLegalMove = gameState.legalMoveDestinations.contains(position)
        let isCapture = gameState.captureMoveDestinations.contains(position)
        let isLastMoveFrom = gameState.lastMove?.from == position
        let isLastMoveTo = gameState.lastMove?.to == position

        // Check if this square contains a king in check
        let isInCheck: Bool = {
            if case .check(let color) = gameState.gameStatus,
               let piece = piece,
               piece.type == .king && piece.color == color {
                return true
            }
            return false
        }()

        SquareView(
            position: position,
            piece: piece,
            isSelected: isSelected,
            isLegalMove: isLegalMove,
            isCapture: isCapture,
            isLastMoveFrom: isLastMoveFrom,
            isLastMoveTo: isLastMoveTo,
            isInCheck: isInCheck,
            size: squareSize,
            onTap: {
                withAnimation(.easeInOut(duration: 0.1)) {
                    gameState.tapSquare(at: position)
                }
            }
        )
    }
}

#Preview {
    ChessBoardView(gameState: GameState(), boardSize: 350)
        .padding()
}
