//
//  PieceView.swift
//  chess-swift
//
//  Chess piece visual representation
//

import SwiftUI

struct PieceView: View {
    let piece: Piece
    let size: CGFloat

    var body: some View {
        Text(piece.unicodeCharacter)
            .font(.system(size: size * 0.75))
            .foregroundStyle(piece.color == .white ? .white : .black)
            .shadow(color: piece.color == .white ? .black.opacity(0.5) : .white.opacity(0.5), radius: 1, x: 0, y: 1)
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            ForEach([PieceType.king, .queen, .rook, .bishop, .knight, .pawn], id: \.self) { type in
                PieceView(piece: Piece(type: type, color: .white), size: 50)
            }
        }
        HStack(spacing: 20) {
            ForEach([PieceType.king, .queen, .rook, .bishop, .knight, .pawn], id: \.self) { type in
                PieceView(piece: Piece(type: type, color: .black), size: 50)
            }
        }
    }
    .padding()
    .background(Color.gray)
}
