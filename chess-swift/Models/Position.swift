//
//  Position.swift
//  chess-swift
//
//  Board position model
//

import Foundation

/// Represents a position on the chess board
struct Position: Equatable, Hashable, Codable {
    /// Row index (0-7, where 0 is the top of the board - black's back rank)
    let row: Int
    /// Column index (0-7, where 0 is the left - 'a' file)
    let col: Int

    /// Whether this position is valid (within board bounds)
    var isValid: Bool {
        row >= 0 && row < 8 && col >= 0 && col < 8
    }

    /// File letter (a-h)
    var file: String {
        guard isValid else { return "?" }
        return String(Character(UnicodeScalar(97 + col)!))  // 'a' = 97
    }

    /// Rank number (1-8, from white's perspective)
    var rank: Int {
        8 - row
    }

    /// Algebraic notation for this position (e.g., "e4")
    var algebraic: String {
        "\(file)\(rank)"
    }

    /// Creates a position from algebraic notation (e.g., "e4")
    init?(algebraic: String) {
        guard algebraic.count == 2 else { return nil }
        let chars = Array(algebraic.lowercased())
        guard let fileChar = chars.first,
              let rankChar = chars.last,
              let fileValue = fileChar.asciiValue,
              let rankValue = rankChar.wholeNumberValue else { return nil }

        let col = Int(fileValue) - 97  // 'a' = 97
        let row = 8 - rankValue

        guard col >= 0 && col < 8 && row >= 0 && row < 8 else { return nil }

        self.row = row
        self.col = col
    }

    /// Creates a position from row and column indices
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }

    /// Returns a new position offset by the given delta
    func offset(deltaRow: Int, deltaCol: Int) -> Position {
        Position(row: row + deltaRow, col: col + deltaCol)
    }

    /// Whether this square is a light square
    var isLightSquare: Bool {
        (row + col) % 2 == 1
    }
}
