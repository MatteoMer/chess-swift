//
//  PawnPromotionView.swift
//  chess-swift
//
//  Pawn promotion selection dialog
//

import SwiftUI

struct PawnPromotionView: View {
    let pawnColor: PieceColor
    let onSelect: (PieceType) -> Void
    let onCancel: () -> Void

    private let promotionOptions: [PieceType] = [.queen, .rook, .bishop, .knight]

    var body: some View {
        VStack(spacing: 16) {
            Text("Promote Pawn")
                .font(.headline)

            HStack(spacing: 12) {
                ForEach(promotionOptions, id: \.self) { pieceType in
                    Button(action: { onSelect(pieceType) }) {
                        VStack(spacing: 4) {
                            Text(Piece(type: pieceType, color: pawnColor).unicodeCharacter)
                                .font(.system(size: 40))

                            Text(pieceType.rawValue.capitalized)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(width: 70, height: 80)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            Button("Cancel", action: onCancel)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
        )
        .shadow(radius: 20)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
            .ignoresSafeArea()

        PawnPromotionView(
            pawnColor: .white,
            onSelect: { _ in },
            onCancel: {}
        )
    }
}
