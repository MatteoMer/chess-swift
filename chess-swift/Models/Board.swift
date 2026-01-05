//
//  Board.swift
//  chess-swift
//
//  Chess board model
//

import Foundation

/// Represents the chess board state
struct Board: Equatable {
    /// 8x8 grid of squares, each containing an optional piece
    /// Row 0 is black's back rank, Row 7 is white's back rank
    private(set) var squares: [[Piece?]]

    /// Creates a board with the standard starting position
    init() {
        squares = Array(repeating: Array(repeating: nil, count: 8), count: 8)
        setupInitialPosition()
    }

    /// Creates a board from a specific squares array (for testing)
    init(squares: [[Piece?]]) {
        self.squares = squares
    }

    /// Sets up the standard starting position
    private mutating func setupInitialPosition() {
        // Black pieces (row 0)
        squares[0] = [
            Piece(type: .rook, color: .black),
            Piece(type: .knight, color: .black),
            Piece(type: .bishop, color: .black),
            Piece(type: .queen, color: .black),
            Piece(type: .king, color: .black),
            Piece(type: .bishop, color: .black),
            Piece(type: .knight, color: .black),
            Piece(type: .rook, color: .black)
        ]

        // Black pawns (row 1)
        squares[1] = Array(repeating: Piece(type: .pawn, color: .black), count: 8)

        // Empty rows (2-5)
        for row in 2...5 {
            squares[row] = Array(repeating: nil, count: 8)
        }

        // White pawns (row 6)
        squares[6] = Array(repeating: Piece(type: .pawn, color: .white), count: 8)

        // White pieces (row 7)
        squares[7] = [
            Piece(type: .rook, color: .white),
            Piece(type: .knight, color: .white),
            Piece(type: .bishop, color: .white),
            Piece(type: .queen, color: .white),
            Piece(type: .king, color: .white),
            Piece(type: .bishop, color: .white),
            Piece(type: .knight, color: .white),
            Piece(type: .rook, color: .white)
        ]
    }

    /// Gets the piece at a position
    func piece(at position: Position) -> Piece? {
        guard position.isValid else { return nil }
        return squares[position.row][position.col]
    }

    /// Sets the piece at a position
    mutating func setPiece(_ piece: Piece?, at position: Position) {
        guard position.isValid else { return }
        squares[position.row][position.col] = piece
    }

    /// Moves a piece from one position to another
    mutating func movePiece(from: Position, to: Position) {
        guard from.isValid && to.isValid else { return }
        let piece = squares[from.row][from.col]
        squares[from.row][from.col] = nil
        squares[to.row][to.col] = piece
    }

    /// Finds the position of the king for a given color
    func findKing(color: PieceColor) -> Position? {
        for row in 0..<8 {
            for col in 0..<8 {
                if let piece = squares[row][col],
                   piece.type == .king && piece.color == color {
                    return Position(row: row, col: col)
                }
            }
        }
        return nil
    }

    /// Gets all positions with pieces of a given color
    func positions(for color: PieceColor) -> [Position] {
        var positions: [Position] = []
        for row in 0..<8 {
            for col in 0..<8 {
                if let piece = squares[row][col], piece.color == color {
                    positions.append(Position(row: row, col: col))
                }
            }
        }
        return positions
    }

    /// Creates a copy of the board with a move applied (for checking hypothetical positions)
    func applying(move: Move) -> Board {
        var newBoard = self

        // Remove piece from source
        newBoard.squares[move.from.row][move.from.col] = nil

        // Handle special moves
        switch move.specialMove {
        case .castleKingside:
            // Move the rook
            let rookFromCol = 7
            let rookToCol = 5
            let row = move.from.row
            let rook = newBoard.squares[row][rookFromCol]
            newBoard.squares[row][rookFromCol] = nil
            newBoard.squares[row][rookToCol] = rook
            newBoard.squares[move.to.row][move.to.col] = move.piece

        case .castleQueenside:
            // Move the rook
            let rookFromCol = 0
            let rookToCol = 3
            let row = move.from.row
            let rook = newBoard.squares[row][rookFromCol]
            newBoard.squares[row][rookFromCol] = nil
            newBoard.squares[row][rookToCol] = rook
            newBoard.squares[move.to.row][move.to.col] = move.piece

        case .enPassant:
            // Remove the captured pawn
            let capturedPawnRow = move.from.row
            newBoard.squares[capturedPawnRow][move.to.col] = nil
            newBoard.squares[move.to.row][move.to.col] = move.piece

        case .pawnPromotion(let promotedPiece):
            // Place the promoted piece instead of the pawn
            newBoard.squares[move.to.row][move.to.col] = Piece(type: promotedPiece, color: move.piece.color)

        case .normal, .pawnDoubleMove:
            newBoard.squares[move.to.row][move.to.col] = move.piece
        }

        return newBoard
    }
}
