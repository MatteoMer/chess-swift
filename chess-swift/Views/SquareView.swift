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

    // Board colors
    private let lightSquareColor = Color(red: 240/255, green: 217/255, blue: 181/255)
    private let darkSquareColor = Color(red: 181/255, green: 136/255, blue: 99/255)
    private let selectedColor = Color.yellow.opacity(0.5)
    private let lastMoveColor = Color.yellow.opacity(0.3)
    private let checkColor = Color.red.opacity(0.6)
    private let legalMoveColor = Color.green.opacity(0.4)

    private var backgroundColor: Color {
        let baseColor = position.isLightSquare ? lightSquareColor : darkSquareColor

        if isInCheck {
            return checkColor
        }
        if isSelected {
            return selectedColor
        }
        if isLastMoveFrom || isLastMoveTo {
            return baseColor.opacity(0.7).blend(with: lastMoveColor)
        }
        return baseColor
    }

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Background
                Rectangle()
                    .fill(backgroundColor)

                // Last move highlight
                if isLastMoveFrom || isLastMoveTo {
                    Rectangle()
                        .fill(lastMoveColor)
                }

                // Legal move indicator
                if isLegalMove {
                    if isCapture {
                        // Capture indicator - corner triangles
                        CaptureIndicator()
                            .fill(legalMoveColor)
                    } else {
                        // Regular move - dot
                        Circle()
                            .fill(Color.black.opacity(0.2))
                            .frame(width: size * 0.3, height: size * 0.3)
                    }
                }

                // Piece
                if let piece = piece {
                    PieceView(piece: piece, size: size)
                }

                // Coordinate labels (optional - for corner squares only)
                coordinateLabels
            }
        }
        .buttonStyle(.plain)
        .frame(width: size, height: size)
    }

    @ViewBuilder
    private var coordinateLabels: some View {
        let textColor = position.isLightSquare ? darkSquareColor : lightSquareColor

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

// Capture indicator shape
struct CaptureIndicator: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerSize = rect.width * 0.25

        // Top-left corner
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: cornerSize, y: 0))
        path.addLine(to: CGPoint(x: 0, y: cornerSize))
        path.closeSubpath()

        // Top-right corner
        path.move(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width - cornerSize, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: cornerSize))
        path.closeSubpath()

        // Bottom-left corner
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: cornerSize, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height - cornerSize))
        path.closeSubpath()

        // Bottom-right corner
        path.move(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width - cornerSize, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerSize))
        path.closeSubpath()

        return path
    }
}

// Color blending extension
extension Color {
    func blend(with color: Color) -> Color {
        // Simple blend implementation
        return self.opacity(0.7)
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
