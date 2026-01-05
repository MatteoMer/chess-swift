//
//  MoveHistoryView.swift
//  chess-swift
//
//  Move history panel with algebraic notation
//

import SwiftUI

struct MoveHistoryView: View {
    let moveRecords: [MoveRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Move History")
                .font(.headline)
                .padding(.horizontal)

            if moveRecords.isEmpty {
                Text("No moves yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 4) {
                            ForEach(moveRecords) { record in
                                MoveRecordRow(record: record)
                                    .id(record.id)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .onChange(of: moveRecords.count) { _, _ in
                        if let lastRecord = moveRecords.last {
                            withAnimation {
                                proxy.scrollTo(lastRecord.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct MoveRecordRow: View {
    let record: MoveRecord

    var body: some View {
        HStack(spacing: 8) {
            Text("\(record.moveNumber).")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 24, alignment: .trailing)

            if let whiteMove = record.whiteMove {
                MoveText(notation: whiteMove.algebraicNotation, isCheck: whiteMove.isCheck, isCheckmate: whiteMove.isCheckmate)
                    .frame(width: 60, alignment: .leading)
            } else {
                Text("")
                    .frame(width: 60)
            }

            if let blackMove = record.blackMove {
                MoveText(notation: blackMove.algebraicNotation, isCheck: blackMove.isCheck, isCheckmate: blackMove.isCheckmate)
                    .frame(width: 60, alignment: .leading)
            }

            Spacer()
        }
        .padding(.vertical, 2)
    }
}

struct MoveText: View {
    let notation: String
    let isCheck: Bool
    let isCheckmate: Bool

    var body: some View {
        Text(notation)
            .font(.system(.subheadline, design: .monospaced))
            .fontWeight(isCheckmate ? .bold : .regular)
            .foregroundStyle(isCheckmate ? .red : (isCheck ? .orange : .primary))
    }
}

#Preview {
    // Create a sample game state with some moves
    let gameState = GameState()
    // Simulate some moves for preview
    let sampleRecords = [
        MoveRecord(moveNumber: 1, whiteMove: Move(piece: Piece(type: .pawn, color: .white), from: Position(row: 6, col: 4), to: Position(row: 4, col: 4)), blackMove: Move(piece: Piece(type: .pawn, color: .black), from: Position(row: 1, col: 4), to: Position(row: 3, col: 4))),
        MoveRecord(moveNumber: 2, whiteMove: Move(piece: Piece(type: .knight, color: .white), from: Position(row: 7, col: 6), to: Position(row: 5, col: 5)), blackMove: Move(piece: Piece(type: .knight, color: .black), from: Position(row: 0, col: 1), to: Position(row: 2, col: 2)))
    ]

    MoveHistoryView(moveRecords: sampleRecords)
        .frame(height: 200)
        .padding()
}
