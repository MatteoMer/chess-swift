//
//  MoveValidator.swift
//  chess-swift
//
//  Chess move validation logic
//

import Foundation

/// Handles chess move validation
struct MoveValidator {

    /// Generates all legal moves for a piece at the given position
    static func legalMoves(
        for position: Position,
        board: Board,
        lastMove: Move?,
        kingHasMoved: [PieceColor: Bool],
        rookHasMoved: [PieceColor: [Int: Bool]]  // [color: [col: hasMoved]]
    ) -> [Move] {
        guard let piece = board.piece(at: position) else { return [] }

        // Generate pseudo-legal moves (moves that follow piece movement rules)
        let pseudoLegalMoves = generatePseudoLegalMoves(
            for: piece,
            at: position,
            board: board,
            lastMove: lastMove,
            kingHasMoved: kingHasMoved,
            rookHasMoved: rookHasMoved
        )

        // Filter to only include moves that don't leave the king in check
        return pseudoLegalMoves.filter { move in
            !wouldLeaveKingInCheck(move: move, board: board, color: piece.color)
        }
    }

    /// Generates pseudo-legal moves for a piece (without checking for leaving king in check)
    private static func generatePseudoLegalMoves(
        for piece: Piece,
        at position: Position,
        board: Board,
        lastMove: Move?,
        kingHasMoved: [PieceColor: Bool],
        rookHasMoved: [PieceColor: [Int: Bool]]
    ) -> [Move] {
        switch piece.type {
        case .pawn:
            return pawnMoves(for: piece, at: position, board: board, lastMove: lastMove)
        case .knight:
            return knightMoves(for: piece, at: position, board: board)
        case .bishop:
            return bishopMoves(for: piece, at: position, board: board)
        case .rook:
            return rookMoves(for: piece, at: position, board: board)
        case .queen:
            return queenMoves(for: piece, at: position, board: board)
        case .king:
            return kingMoves(for: piece, at: position, board: board, kingHasMoved: kingHasMoved, rookHasMoved: rookHasMoved)
        }
    }

    // MARK: - Piece-specific move generation

    private static func pawnMoves(for piece: Piece, at position: Position, board: Board, lastMove: Move?) -> [Move] {
        var moves: [Move] = []
        let direction = piece.color == .white ? -1 : 1
        let startRow = piece.color == .white ? 6 : 1
        let promotionRow = piece.color == .white ? 0 : 7

        // Forward move
        let oneStep = position.offset(deltaRow: direction, deltaCol: 0)
        if oneStep.isValid && board.piece(at: oneStep) == nil {
            if oneStep.row == promotionRow {
                // Pawn promotion
                for promotionType in [PieceType.queen, .rook, .bishop, .knight] {
                    moves.append(Move(piece: piece, from: position, to: oneStep, specialMove: .pawnPromotion(promotionType)))
                }
            } else {
                moves.append(Move(piece: piece, from: position, to: oneStep))
            }

            // Double move from starting position
            if position.row == startRow {
                let twoStep = position.offset(deltaRow: direction * 2, deltaCol: 0)
                if twoStep.isValid && board.piece(at: twoStep) == nil {
                    moves.append(Move(piece: piece, from: position, to: twoStep, specialMove: .pawnDoubleMove))
                }
            }
        }

        // Captures (diagonal)
        for deltaCol in [-1, 1] {
            let capturePos = position.offset(deltaRow: direction, deltaCol: deltaCol)
            if capturePos.isValid {
                if let targetPiece = board.piece(at: capturePos), targetPiece.color != piece.color {
                    if capturePos.row == promotionRow {
                        // Capture with promotion
                        for promotionType in [PieceType.queen, .rook, .bishop, .knight] {
                            moves.append(Move(piece: piece, from: position, to: capturePos, capturedPiece: targetPiece, specialMove: .pawnPromotion(promotionType)))
                        }
                    } else {
                        moves.append(Move(piece: piece, from: position, to: capturePos, capturedPiece: targetPiece))
                    }
                }

                // En passant
                if let lastMove = lastMove,
                   lastMove.piece.type == .pawn,
                   lastMove.specialMove == .pawnDoubleMove,
                   lastMove.to.row == position.row,
                   lastMove.to.col == capturePos.col {
                    moves.append(Move(piece: piece, from: position, to: capturePos, capturedPiece: lastMove.piece, specialMove: .enPassant))
                }
            }
        }

        return moves
    }

    private static func knightMoves(for piece: Piece, at position: Position, board: Board) -> [Move] {
        var moves: [Move] = []
        let deltas = [
            (-2, -1), (-2, 1), (-1, -2), (-1, 2),
            (1, -2), (1, 2), (2, -1), (2, 1)
        ]

        for (deltaRow, deltaCol) in deltas {
            let newPos = position.offset(deltaRow: deltaRow, deltaCol: deltaCol)
            if newPos.isValid {
                if let targetPiece = board.piece(at: newPos) {
                    if targetPiece.color != piece.color {
                        moves.append(Move(piece: piece, from: position, to: newPos, capturedPiece: targetPiece))
                    }
                } else {
                    moves.append(Move(piece: piece, from: position, to: newPos))
                }
            }
        }

        return moves
    }

    private static func bishopMoves(for piece: Piece, at position: Position, board: Board) -> [Move] {
        return slidingMoves(for: piece, at: position, board: board, directions: [(-1, -1), (-1, 1), (1, -1), (1, 1)])
    }

    private static func rookMoves(for piece: Piece, at position: Position, board: Board) -> [Move] {
        return slidingMoves(for: piece, at: position, board: board, directions: [(-1, 0), (1, 0), (0, -1), (0, 1)])
    }

    private static func queenMoves(for piece: Piece, at position: Position, board: Board) -> [Move] {
        return slidingMoves(for: piece, at: position, board: board, directions: [
            (-1, -1), (-1, 0), (-1, 1),
            (0, -1), (0, 1),
            (1, -1), (1, 0), (1, 1)
        ])
    }

    private static func slidingMoves(for piece: Piece, at position: Position, board: Board, directions: [(Int, Int)]) -> [Move] {
        var moves: [Move] = []

        for (deltaRow, deltaCol) in directions {
            var newPos = position.offset(deltaRow: deltaRow, deltaCol: deltaCol)
            while newPos.isValid {
                if let targetPiece = board.piece(at: newPos) {
                    if targetPiece.color != piece.color {
                        moves.append(Move(piece: piece, from: position, to: newPos, capturedPiece: targetPiece))
                    }
                    break  // Can't move past any piece
                } else {
                    moves.append(Move(piece: piece, from: position, to: newPos))
                }
                newPos = newPos.offset(deltaRow: deltaRow, deltaCol: deltaCol)
            }
        }

        return moves
    }

    private static func kingMoves(
        for piece: Piece,
        at position: Position,
        board: Board,
        kingHasMoved: [PieceColor: Bool],
        rookHasMoved: [PieceColor: [Int: Bool]]
    ) -> [Move] {
        var moves: [Move] = []

        // Regular king moves
        for deltaRow in -1...1 {
            for deltaCol in -1...1 {
                if deltaRow == 0 && deltaCol == 0 { continue }
                let newPos = position.offset(deltaRow: deltaRow, deltaCol: deltaCol)
                if newPos.isValid {
                    if let targetPiece = board.piece(at: newPos) {
                        if targetPiece.color != piece.color {
                            moves.append(Move(piece: piece, from: position, to: newPos, capturedPiece: targetPiece))
                        }
                    } else {
                        moves.append(Move(piece: piece, from: position, to: newPos))
                    }
                }
            }
        }

        // Castling
        if kingHasMoved[piece.color] != true {
            let row = piece.color == .white ? 7 : 0

            // Kingside castling
            if rookHasMoved[piece.color]?[7] != true {
                if let rook = board.piece(at: Position(row: row, col: 7)),
                   rook.type == .rook && rook.color == piece.color {
                    // Check if squares between king and rook are empty
                    let f = Position(row: row, col: 5)
                    let g = Position(row: row, col: 6)
                    if board.piece(at: f) == nil && board.piece(at: g) == nil {
                        // Check if king passes through or ends on attacked square
                        if !isSquareAttacked(position, by: piece.color.opposite, board: board) &&
                           !isSquareAttacked(f, by: piece.color.opposite, board: board) &&
                           !isSquareAttacked(g, by: piece.color.opposite, board: board) {
                            moves.append(Move(piece: piece, from: position, to: g, specialMove: .castleKingside))
                        }
                    }
                }
            }

            // Queenside castling
            if rookHasMoved[piece.color]?[0] != true {
                if let rook = board.piece(at: Position(row: row, col: 0)),
                   rook.type == .rook && rook.color == piece.color {
                    // Check if squares between king and rook are empty
                    let b = Position(row: row, col: 1)
                    let c = Position(row: row, col: 2)
                    let d = Position(row: row, col: 3)
                    if board.piece(at: b) == nil && board.piece(at: c) == nil && board.piece(at: d) == nil {
                        // Check if king passes through or ends on attacked square
                        if !isSquareAttacked(position, by: piece.color.opposite, board: board) &&
                           !isSquareAttacked(c, by: piece.color.opposite, board: board) &&
                           !isSquareAttacked(d, by: piece.color.opposite, board: board) {
                            moves.append(Move(piece: piece, from: position, to: c, specialMove: .castleQueenside))
                        }
                    }
                }
            }
        }

        return moves
    }

    // MARK: - Check detection

    /// Checks if a square is attacked by any piece of the given color
    static func isSquareAttacked(_ position: Position, by color: PieceColor, board: Board) -> Bool {
        for row in 0..<8 {
            for col in 0..<8 {
                let pos = Position(row: row, col: col)
                if let piece = board.piece(at: pos), piece.color == color {
                    if canAttack(from: pos, to: position, piece: piece, board: board) {
                        return true
                    }
                }
            }
        }
        return false
    }

    /// Checks if a piece can attack a target square (ignoring check constraints)
    private static func canAttack(from: Position, to: Position, piece: Piece, board: Board) -> Bool {
        let deltaRow = to.row - from.row
        let deltaCol = to.col - from.col

        switch piece.type {
        case .pawn:
            let direction = piece.color == .white ? -1 : 1
            return deltaRow == direction && abs(deltaCol) == 1

        case .knight:
            return (abs(deltaRow) == 2 && abs(deltaCol) == 1) || (abs(deltaRow) == 1 && abs(deltaCol) == 2)

        case .bishop:
            if abs(deltaRow) != abs(deltaCol) || deltaRow == 0 { return false }
            return isPathClear(from: from, to: to, board: board)

        case .rook:
            if deltaRow != 0 && deltaCol != 0 { return false }
            return isPathClear(from: from, to: to, board: board)

        case .queen:
            if deltaRow != 0 && deltaCol != 0 && abs(deltaRow) != abs(deltaCol) { return false }
            return isPathClear(from: from, to: to, board: board)

        case .king:
            return abs(deltaRow) <= 1 && abs(deltaCol) <= 1
        }
    }

    /// Checks if the path between two positions is clear (for sliding pieces)
    private static func isPathClear(from: Position, to: Position, board: Board) -> Bool {
        let deltaRow = to.row - from.row
        let deltaCol = to.col - from.col
        let stepRow = deltaRow == 0 ? 0 : deltaRow / abs(deltaRow)
        let stepCol = deltaCol == 0 ? 0 : deltaCol / abs(deltaCol)

        var currentPos = from.offset(deltaRow: stepRow, deltaCol: stepCol)
        while currentPos != to {
            if board.piece(at: currentPos) != nil {
                return false
            }
            currentPos = currentPos.offset(deltaRow: stepRow, deltaCol: stepCol)
        }
        return true
    }

    /// Checks if a move would leave the moving player's king in check
    static func wouldLeaveKingInCheck(move: Move, board: Board, color: PieceColor) -> Bool {
        let newBoard = board.applying(move: move)
        guard let kingPosition = newBoard.findKing(color: color) else { return true }
        return isSquareAttacked(kingPosition, by: color.opposite, board: newBoard)
    }

    /// Checks if the given color's king is in check
    static func isInCheck(color: PieceColor, board: Board) -> Bool {
        guard let kingPosition = board.findKing(color: color) else { return false }
        return isSquareAttacked(kingPosition, by: color.opposite, board: board)
    }

    /// Checks if the given color has any legal moves
    static func hasLegalMoves(
        color: PieceColor,
        board: Board,
        lastMove: Move?,
        kingHasMoved: [PieceColor: Bool],
        rookHasMoved: [PieceColor: [Int: Bool]]
    ) -> Bool {
        for position in board.positions(for: color) {
            let moves = legalMoves(for: position, board: board, lastMove: lastMove, kingHasMoved: kingHasMoved, rookHasMoved: rookHasMoved)
            if !moves.isEmpty {
                return true
            }
        }
        return false
    }
}
