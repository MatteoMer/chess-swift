//
//  Move.swift
//  chess-swift
//
//  Chess move model
//

import Foundation

/// Represents special move types
enum SpecialMoveType: Equatable, Codable {
    case normal
    case castleKingside
    case castleQueenside
    case enPassant
    case pawnPromotion(PieceType)
    case pawnDoubleMove  // Used for tracking en passant eligibility
}

/// Represents a chess move
struct Move: Equatable, Codable {
    /// The piece that was moved
    let piece: Piece
    /// Starting position
    let from: Position
    /// Ending position
    let to: Position
    /// Piece that was captured (if any)
    let capturedPiece: Piece?
    /// Type of special move (if applicable)
    let specialMove: SpecialMoveType
    /// Whether this move put the opponent in check
    var isCheck: Bool = false
    /// Whether this move resulted in checkmate
    var isCheckmate: Bool = false

    /// Creates a standard move
    init(piece: Piece, from: Position, to: Position, capturedPiece: Piece? = nil, specialMove: SpecialMoveType = .normal) {
        self.piece = piece
        self.from = from
        self.to = to
        self.capturedPiece = capturedPiece
        self.specialMove = specialMove
    }

    /// Algebraic notation for this move
    var algebraicNotation: String {
        var notation = ""

        // Handle castling
        switch specialMove {
        case .castleKingside:
            return isCheckmate ? "O-O#" : (isCheck ? "O-O+" : "O-O")
        case .castleQueenside:
            return isCheckmate ? "O-O-O#" : (isCheck ? "O-O-O+" : "O-O-O")
        default:
            break
        }

        // Piece notation (empty for pawns)
        notation += piece.type.notationCharacter

        // For pawns capturing, include the file
        if piece.type == .pawn && capturedPiece != nil {
            notation += from.file
        }

        // Capture symbol
        if capturedPiece != nil {
            notation += "x"
        }

        // Destination square
        notation += to.algebraic

        // Promotion
        if case .pawnPromotion(let promotedTo) = specialMove {
            notation += "=\(promotedTo.notationCharacter)"
        }

        // Check or checkmate
        if isCheckmate {
            notation += "#"
        } else if isCheck {
            notation += "+"
        }

        return notation
    }
}

/// Represents a move for display in move history (with move number)
struct MoveRecord: Identifiable, Equatable {
    let id = UUID()
    let moveNumber: Int
    let whiteMove: Move?
    let blackMove: Move?

    var displayText: String {
        var text = "\(moveNumber)."
        if let white = whiteMove {
            text += " \(white.algebraicNotation)"
        }
        if let black = blackMove {
            text += " \(black.algebraicNotation)"
        }
        return text
    }
}
