//
//  GameInfoView.swift
//  chess-swift
//
//  Game information display (turn, captured pieces, status)
//

import SwiftUI

struct GameInfoView: View {
    let gameState: GameState

    var body: some View {
        VStack(spacing: 16) {
            // Status text
            Text(gameState.statusText)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(statusTextColor)
                .animation(.easeInOut, value: gameState.statusText)

            // Turn indicator
            if !gameState.isGameOver {
                HStack(spacing: 8) {
                    Circle()
                        .fill(gameState.currentTurn == .white ? .white : .black)
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 20, height: 20)
                    Text("to move")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            // Captured pieces
            VStack(spacing: 8) {
                CapturedPiecesRow(pieces: gameState.capturedPieces[.black] ?? [], label: "Captured by White")
                CapturedPiecesRow(pieces: gameState.capturedPieces[.white] ?? [], label: "Captured by Black")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }

    private var statusTextColor: Color {
        switch gameState.gameStatus {
        case .check:
            return .orange
        case .checkmate, .resigned:
            return .red
        case .stalemate:
            return .blue
        default:
            return .primary
        }
    }
}

struct CapturedPiecesRow: View {
    let pieces: [Piece]
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 2) {
                ForEach(sortedPieces.indices, id: \.self) { index in
                    Text(sortedPieces[index].unicodeCharacter)
                        .font(.system(size: 18))
                }

                if pieces.isEmpty {
                    Text("None")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                // Material count
                Text("+\(materialValue)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .opacity(materialValue > 0 ? 1 : 0)
            }
        }
    }

    private var sortedPieces: [Piece] {
        pieces.sorted { $0.type.pointValue > $1.type.pointValue }
    }

    private var materialValue: Int {
        pieces.reduce(0) { $0 + $1.type.pointValue }
    }
}

#Preview {
    VStack {
        GameInfoView(gameState: GameState())
    }
    .padding()
}
