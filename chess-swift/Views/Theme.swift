//
//  Theme.swift
//  chess-swift
//
//  Theme colors and styles for the chess app
//

import SwiftUI

/// Chess app theme colors
enum ChessTheme {
    // Board colors - classic wood tones
    static let lightSquare = Color(red: 240/255, green: 217/255, blue: 181/255)
    static let darkSquare = Color(red: 181/255, green: 136/255, blue: 99/255)

    // Highlight colors
    static let selectedSquare = Color.yellow.opacity(0.6)
    static let lastMoveHighlight = Color.yellow.opacity(0.35)
    static let legalMoveIndicator = Color(red: 0.3, green: 0.7, blue: 0.3).opacity(0.6)
    static let captureIndicator = Color(red: 0.9, green: 0.3, blue: 0.3).opacity(0.6)
    static let checkHighlight = Color.red.opacity(0.7)

    // Piece colors
    static let whitePiece = Color.white
    static let blackPiece = Color.black
    static let whitePieceShadow = Color.black.opacity(0.4)
    static let blackPieceShadow = Color.white.opacity(0.4)

    // UI colors
    static let primaryBackground = Color(red: 0.12, green: 0.12, blue: 0.16)
    static let secondaryBackground = Color(red: 0.18, green: 0.18, blue: 0.22)
    static let cardBackground = Color(red: 0.2, green: 0.2, blue: 0.24)

    // Accent colors
    static let accentGreen = Color(red: 0.4, green: 0.8, blue: 0.4)
    static let accentRed = Color(red: 0.9, green: 0.4, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.7, blue: 0.3)
    static let accentBlue = Color(red: 0.4, green: 0.6, blue: 0.9)
}

/// Board style variants
enum BoardStyle: String, CaseIterable {
    case classic = "Classic"
    case modern = "Modern"
    case tournament = "Tournament"

    var lightSquareColor: Color {
        switch self {
        case .classic:
            return Color(red: 240/255, green: 217/255, blue: 181/255)
        case .modern:
            return Color(red: 238/255, green: 238/255, blue: 210/255)
        case .tournament:
            return Color(red: 235/255, green: 236/255, blue: 208/255)
        }
    }

    var darkSquareColor: Color {
        switch self {
        case .classic:
            return Color(red: 181/255, green: 136/255, blue: 99/255)
        case .modern:
            return Color(red: 118/255, green: 150/255, blue: 86/255)
        case .tournament:
            return Color(red: 119/255, green: 149/255, blue: 86/255)
        }
    }
}

/// Custom button style for the app
struct ChessButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .shadow(color: .black.opacity(0.3), radius: configuration.isPressed ? 2 : 4, y: configuration.isPressed ? 1 : 2)
            )
            .foregroundStyle(foregroundColor)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension View {
    func chessButtonStyle(backgroundColor: Color = ChessTheme.accentBlue, foregroundColor: Color = .white) -> some View {
        self.buttonStyle(ChessButtonStyle(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
    }
}
