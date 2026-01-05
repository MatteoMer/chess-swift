//
//  GameOverView.swift
//  chess-swift
//
//  Game over screen
//

import SwiftUI

struct GameOverView: View {
    let gameStatus: GameStatus
    let onNewGame: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            // Icon
            Image(systemName: iconName)
                .font(.system(size: 60))
                .foregroundStyle(iconColor)

            // Title
            Text(title)
                .font(.title)
                .fontWeight(.bold)

            // Subtitle
            Text(subtitle)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Divider()
                .padding(.horizontal)

            // Buttons
            VStack(spacing: 12) {
                Button(action: onNewGame) {
                    Label("New Game", systemImage: "arrow.counterclockwise")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button(action: onDismiss) {
                    Text("Review Board")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.regularMaterial)
        )
        .shadow(radius: 20)
        .padding(40)
    }

    private var iconName: String {
        switch gameStatus {
        case .checkmate:
            return "crown.fill"
        case .stalemate:
            return "equal.circle.fill"
        case .resigned:
            return "flag.fill"
        default:
            return "questionmark.circle.fill"
        }
    }

    private var iconColor: Color {
        switch gameStatus {
        case .checkmate(let winner):
            return winner == .white ? .yellow : .purple
        case .stalemate:
            return .blue
        case .resigned:
            return .orange
        default:
            return .gray
        }
    }

    private var title: String {
        switch gameStatus {
        case .checkmate:
            return "Checkmate!"
        case .stalemate:
            return "Stalemate"
        case .resigned:
            return "Resignation"
        default:
            return "Game Over"
        }
    }

    private var subtitle: String {
        switch gameStatus {
        case .checkmate(let winner):
            return "\(winner.displayName) wins by checkmate"
        case .stalemate:
            return "The game is a draw"
        case .resigned(let winner):
            return "\(winner.displayName) wins by resignation"
        default:
            return ""
        }
    }
}

#Preview {
    VStack {
        GameOverView(
            gameStatus: .checkmate(winner: .white),
            onNewGame: {},
            onDismiss: {}
        )

        GameOverView(
            gameStatus: .stalemate,
            onNewGame: {},
            onDismiss: {}
        )
    }
}
