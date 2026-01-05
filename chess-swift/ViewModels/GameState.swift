//
//  GameState.swift
//  chess-swift
//
//  Game state management
//

import Foundation
import SwiftUI

/// Represents the current state of the game
enum GameStatus: Equatable {
    case playing
    case check(PieceColor)
    case checkmate(winner: PieceColor)
    case stalemate
    case resigned(winner: PieceColor)
}

/// Observable game state
@Observable
class GameState {
    // MARK: - Properties

    /// The current board state
    private(set) var board: Board

    /// Whose turn it is
    private(set) var currentTurn: PieceColor

    /// Currently selected piece position
    var selectedPosition: Position?

    /// Legal moves for the selected piece
    var legalMovesForSelected: [Move] = []

    /// Move history
    private(set) var moveHistory: [Move] = []

    /// Captured pieces for each color
    private(set) var capturedPieces: [PieceColor: [Piece]] = [.white: [], .black: []]

    /// Current game status
    private(set) var gameStatus: GameStatus = .playing

    /// The last move made (for en passant)
    private(set) var lastMove: Move?

    /// Whether each king has moved (for castling)
    private(set) var kingHasMoved: [PieceColor: Bool] = [.white: false, .black: false]

    /// Whether each rook has moved (for castling) - [color: [col: hasMoved]]
    private(set) var rookHasMoved: [PieceColor: [Int: Bool]] = [
        .white: [0: false, 7: false],
        .black: [0: false, 7: false]
    ]

    /// Pending pawn promotion move
    var pendingPromotion: (move: Move, position: Position)?

    // MARK: - Initialization

    init() {
        board = Board()
        currentTurn = .white
    }

    // MARK: - Game Actions

    /// Starts a new game
    func newGame() {
        board = Board()
        currentTurn = .white
        selectedPosition = nil
        legalMovesForSelected = []
        moveHistory = []
        capturedPieces = [.white: [], .black: []]
        gameStatus = .playing
        lastMove = nil
        kingHasMoved = [.white: false, .black: false]
        rookHasMoved = [
            .white: [0: false, 7: false],
            .black: [0: false, 7: false]
        ]
        pendingPromotion = nil
    }

    /// Handles a tap on a square
    func tapSquare(at position: Position) {
        // If game is over, ignore taps
        if case .checkmate = gameStatus { return }
        if case .stalemate = gameStatus { return }
        if case .resigned = gameStatus { return }

        // If there's a pending promotion, ignore other taps
        if pendingPromotion != nil { return }

        // If tapping the already selected piece, deselect it
        if selectedPosition == position {
            selectedPosition = nil
            legalMovesForSelected = []
            return
        }

        // Check if tapping a legal move destination
        if let selected = selectedPosition,
           let move = legalMovesForSelected.first(where: { $0.to == position }) {

            // Check if this is a pawn promotion move
            if case .pawnPromotion = move.specialMove {
                // Show promotion dialog
                pendingPromotion = (move, position)
                return
            }

            // Execute the move
            executeMove(move)
            return
        }

        // Try to select a piece
        if let piece = board.piece(at: position), piece.color == currentTurn {
            selectedPosition = position
            legalMovesForSelected = MoveValidator.legalMoves(
                for: position,
                board: board,
                lastMove: lastMove,
                kingHasMoved: kingHasMoved,
                rookHasMoved: rookHasMoved
            )
        } else {
            selectedPosition = nil
            legalMovesForSelected = []
        }
    }

    /// Completes pawn promotion with the selected piece type
    func completePromotion(with pieceType: PieceType) {
        guard let (baseMove, _) = pendingPromotion else { return }

        // Create the promotion move with the selected piece type
        let promotionMove = Move(
            piece: baseMove.piece,
            from: baseMove.from,
            to: baseMove.to,
            capturedPiece: baseMove.capturedPiece,
            specialMove: .pawnPromotion(pieceType)
        )

        pendingPromotion = nil
        executeMove(promotionMove)
    }

    /// Cancels the pending promotion
    func cancelPromotion() {
        pendingPromotion = nil
        selectedPosition = nil
        legalMovesForSelected = []
    }

    /// Executes a move
    private func executeMove(_ move: Move) {
        // Track captured piece
        if let captured = move.capturedPiece {
            capturedPieces[captured.color, default: []].append(captured)
        }

        // Update castling rights
        if move.piece.type == .king {
            kingHasMoved[move.piece.color] = true
        }
        if move.piece.type == .rook {
            rookHasMoved[move.piece.color]?[move.from.col] = true
        }
        // If a rook is captured, also update castling rights
        if let captured = move.capturedPiece, captured.type == .rook {
            let capturedColor = captured.color
            if move.to.col == 0 {
                rookHasMoved[capturedColor]?[0] = true
            } else if move.to.col == 7 {
                rookHasMoved[capturedColor]?[7] = true
            }
        }

        // Apply the move to the board
        board = board.applying(move: move)

        // Update move with check/checkmate status
        var finalMove = move
        let oppositeColor = move.piece.color.opposite

        if MoveValidator.isInCheck(color: oppositeColor, board: board) {
            // Check if it's checkmate
            if !MoveValidator.hasLegalMoves(
                color: oppositeColor,
                board: board,
                lastMove: move,
                kingHasMoved: kingHasMoved,
                rookHasMoved: rookHasMoved
            ) {
                finalMove.isCheckmate = true
                gameStatus = .checkmate(winner: move.piece.color)
            } else {
                finalMove.isCheck = true
                gameStatus = .check(oppositeColor)
            }
        } else {
            // Check for stalemate
            if !MoveValidator.hasLegalMoves(
                color: oppositeColor,
                board: board,
                lastMove: move,
                kingHasMoved: kingHasMoved,
                rookHasMoved: rookHasMoved
            ) {
                gameStatus = .stalemate
            } else {
                gameStatus = .playing
            }
        }

        // Store the move
        lastMove = finalMove
        moveHistory.append(finalMove)

        // Switch turns
        currentTurn = oppositeColor

        // Clear selection
        selectedPosition = nil
        legalMovesForSelected = []
    }

    /// Resign the game
    func resign() {
        gameStatus = .resigned(winner: currentTurn.opposite)
    }

    // MARK: - Move History Formatting

    /// Gets move records for display
    var moveRecords: [MoveRecord] {
        var records: [MoveRecord] = []
        var moveNumber = 1
        var whiteMoveTemp: Move?

        for (index, move) in moveHistory.enumerated() {
            if index % 2 == 0 {
                // White's move
                whiteMoveTemp = move
            } else {
                // Black's move
                records.append(MoveRecord(moveNumber: moveNumber, whiteMove: whiteMoveTemp, blackMove: move))
                moveNumber += 1
                whiteMoveTemp = nil
            }
        }

        // Add any remaining white move
        if let white = whiteMoveTemp {
            records.append(MoveRecord(moveNumber: moveNumber, whiteMove: white, blackMove: nil))
        }

        return records
    }

    // MARK: - Helpers

    /// Gets legal move destinations for the selected piece
    var legalMoveDestinations: Set<Position> {
        Set(legalMovesForSelected.map { $0.to })
    }

    /// Gets capture move destinations for the selected piece
    var captureMoveDestinations: Set<Position> {
        Set(legalMovesForSelected.filter { $0.capturedPiece != nil }.map { $0.to })
    }

    /// Status text for display
    var statusText: String {
        switch gameStatus {
        case .playing:
            return "\(currentTurn.displayName)'s Turn"
        case .check(let color):
            return "\(color.displayName) is in Check!"
        case .checkmate(let winner):
            return "Checkmate! \(winner.displayName) Wins!"
        case .stalemate:
            return "Stalemate - Draw!"
        case .resigned(let winner):
            return "\(winner.opposite.displayName) Resigned. \(winner.displayName) Wins!"
        }
    }

    /// Whether the game is over
    var isGameOver: Bool {
        switch gameStatus {
        case .checkmate, .stalemate, .resigned:
            return true
        default:
            return false
        }
    }
}
