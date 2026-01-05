//
//  Piece.swift
//  chess-swift
//
//  Chess piece model
//

import Foundation

/// Represents the color of a chess piece
enum PieceColor: String, Codable, CaseIterable {
    case white
    case black

    /// Returns the opposite color
    var opposite: PieceColor {
        self == .white ? .black : .white
    }

    /// Display name for the color
    var displayName: String {
        rawValue.capitalized
    }
}

/// Represents the type of a chess piece
enum PieceType: String, Codable, CaseIterable {
    case king
    case queen
    case rook
    case bishop
    case knight
    case pawn

    /// The SF Symbol name for this piece type
    var symbolName: String {
        switch self {
        case .king: return "crown.fill"
        case .queen: return "diamond.fill"
        case .rook: return "square.fill"
        case .bishop: return "arrowtriangle.up.fill"
        case .knight: return "shield.fill"
        case .pawn: return "circle.fill"
        }
    }

    /// Character representation for algebraic notation (empty for pawn)
    var notationCharacter: String {
        switch self {
        case .king: return "K"
        case .queen: return "Q"
        case .rook: return "R"
        case .bishop: return "B"
        case .knight: return "N"
        case .pawn: return ""
        }
    }

    /// Point value for material calculation
    var pointValue: Int {
        switch self {
        case .king: return 0  // King is invaluable
        case .queen: return 9
        case .rook: return 5
        case .bishop: return 3
        case .knight: return 3
        case .pawn: return 1
        }
    }
}

/// Represents a chess piece with its type and color
struct Piece: Equatable, Codable, Hashable {
    let type: PieceType
    let color: PieceColor

    /// Unicode character for this piece
    var unicodeCharacter: String {
        switch (color, type) {
        case (.white, .king): return "♔"
        case (.white, .queen): return "♕"
        case (.white, .rook): return "♖"
        case (.white, .bishop): return "♗"
        case (.white, .knight): return "♘"
        case (.white, .pawn): return "♙"
        case (.black, .king): return "♚"
        case (.black, .queen): return "♛"
        case (.black, .rook): return "♜"
        case (.black, .bishop): return "♝"
        case (.black, .knight): return "♞"
        case (.black, .pawn): return "♟"
        }
    }

    /// SF Symbol name for this piece
    var sfSymbolName: String {
        type.symbolName
    }
}
