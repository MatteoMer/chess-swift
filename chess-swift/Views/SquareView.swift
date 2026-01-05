//
//  SquareView.swift
//  chess-swift
//
//  Individual chess board square
//

import SwiftUI

struct SquareView: View {
    let position: Position
    let piece: Piece?
    let isSelected: Bool
    let isLegalMove: Bool
    let isCapture: Bool
    let isLastMoveFrom: Bool
    let isLastMoveTo: Bool
    let isInCheck: Bool
    let size: CGFloat
    let onTap: () -> Void

    private var baseColor: Color {
        position.isLightSquare ? ChessTheme.lightSquare : ChessTheme.darkSquare
    }

    private var backgroundColor: Color {
        if isInCheck {
            return ChessTheme.checkHighlight
        }
        if isSelected {
            return ChessTheme.selectedSquare
        }
        return baseColor
    }

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Background
                Rectangle()
                    .fill(backgroundColor)

                // Last move highlight overlay
                if isLastMoveFrom || isLastMoveTo {
                    Rectangle()
                        .fill(ChessTheme.lastMoveHighlight)
                }

                // Legal move indicator
                if isLegalMove {
                    if isCapture || piece != nil {
                        // Capture indicator - ring around piece
                        Circle()
                            .strokeBorder(ChessTheme.captureIndicator, lineWidth: size * 0.08)
                            .frame(width: size * 0.85, height: size * 0.85)
                    } else {
                        // Regular move - dot
                        Circle()
                            .fill(ChessTheme.legalMoveIndicator)
                            .frame(width: size * 0.35, height: size * 0.35)
                    }
                }

                // Piece with animation
                if let piece = piece {
                    PieceView(piece: piece, size: size)
                        .scaleEffect(isSelected ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.15), value: isSelected)
                }

                // Coordinate labels
                coordinateLabels
            }
        }
        .buttonStyle(.plain)
        .frame(width: size, height: size)
    }

    @ViewBuilder
    private var coordinateLabels: some View {
        let textColor = position.isLightSquare ? ChessTheme.darkSquare : ChessTheme.lightSquare

        // File letter on bottom row (row 7)
        if position.row == 7 {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(position.file)
                        .font(.system(size: size * 0.15, weight: .bold))
                        .foregroundStyle(textColor)
                        .padding(2)
                }
            }
        }

        // Rank number on leftmost column (col 0)
        if position.col == 0 {
            VStack {
                HStack {
                    Text("\(position.rank)")
                        .font(.system(size: size * 0.15, weight: .bold))
                        .foregroundStyle(textColor)
                        .padding(2)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}


#Preview {
    VStack {
        HStack {
            SquareView(
                position: Position(row: 0, col: 0),
                piece: Piece(type: .rook, color: .black),
                isSelected: false,
                isLegalMove: false,
                isCapture: false,
                isLastMoveFrom: false,
                isLastMoveTo: false,
                isInCheck: false,
                size: 60,
                onTap: {}
            )
            SquareView(
                position: Position(row: 0, col: 1),
                piece: nil,
                isSelected: false,
                isLegalMove: true,
                isCapture: false,
                isLastMoveFrom: false,
                isLastMoveTo: false,
                isInCheck: false,
                size: 60,
                onTap: {}
            )
        }
        HStack {
            SquareView(
                position: Position(row: 1, col: 0),
                piece: nil,
                isSelected: false,
                isLegalMove: true,
                isCapture: true,
                isLastMoveFrom: false,
                isLastMoveTo: false,
                isInCheck: false,
                size: 60,
                onTap: {}
            )
            SquareView(
                position: Position(row: 1, col: 1),
                piece: Piece(type: .king, color: .white),
                isSelected: true,
                isLegalMove: false,
                isCapture: false,
                isLastMoveFrom: false,
                isLastMoveTo: false,
                isInCheck: true,
                size: 60,
                onTap: {}
            )
        }
    }
}
