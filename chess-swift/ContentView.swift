//
//  ContentView.swift
//  chess-swift
//
//  Main container view
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var gameState = GameState()
    @State private var showGameOverSheet = false
    @State private var showResignConfirmation = false

    private var backgroundColor: LinearGradient {
        if colorScheme == .dark {
            return LinearGradient(
                colors: [Color(red: 0.12, green: 0.12, blue: 0.16), Color(red: 0.08, green: 0.08, blue: 0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [Color(red: 0.95, green: 0.95, blue: 0.97), Color(red: 0.88, green: 0.88, blue: 0.92)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private var textColor: Color {
        colorScheme == .dark ? .white : Color(red: 0.2, green: 0.2, blue: 0.25)
    }

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let boardSize = min(geometry.size.width - 32, geometry.size.height * 0.55)

            ZStack {
                // Background gradient
                backgroundColor
                    .ignoresSafeArea()

                if isLandscape {
                    landscapeLayout(boardSize: min(geometry.size.height - 40, geometry.size.width * 0.5))
                } else {
                    portraitLayout(boardSize: boardSize)
                }

                // Pawn promotion overlay
                if let promotion = gameState.pendingPromotion {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            gameState.cancelPromotion()
                        }

                    PawnPromotionView(
                        pawnColor: promotion.move.piece.color,
                        onSelect: { pieceType in
                            withAnimation {
                                gameState.completePromotion(with: pieceType)
                            }
                            triggerHaptic()
                        },
                        onCancel: {
                            gameState.cancelPromotion()
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }

                // Game over overlay
                if gameState.isGameOver && showGameOverSheet {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showGameOverSheet = false
                        }

                    GameOverView(
                        gameStatus: gameState.gameStatus,
                        onNewGame: {
                            withAnimation {
                                gameState.newGame()
                                showGameOverSheet = false
                            }
                        },
                        onDismiss: {
                            showGameOverSheet = false
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onChange(of: gameState.isGameOver) { _, isOver in
            if isOver {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        showGameOverSheet = true
                    }
                }
            }
        }
        .onChange(of: gameState.lastMove) { _, _ in
            triggerHaptic()
        }
        .confirmationDialog("Resign Game?", isPresented: $showResignConfirmation, titleVisibility: .visible) {
            Button("Resign", role: .destructive) {
                gameState.resign()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to resign? \(gameState.currentTurn.opposite.displayName) will win.")
        }
    }

    @ViewBuilder
    private func portraitLayout(boardSize: CGFloat) -> some View {
        VStack(spacing: 12) {
            // Header
            headerView

            // Game info
            GameInfoView(gameState: gameState)
                .padding(.horizontal)

            // Chess board
            ChessBoardView(gameState: gameState, boardSize: boardSize)
                .padding(.horizontal)

            // Move history
            MoveHistoryView(moveRecords: gameState.moveRecords)
                .frame(minHeight: 80, maxHeight: 150)
                .padding(.horizontal)

            Spacer(minLength: 0)

            // Action buttons
            actionButtons
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
    }

    @ViewBuilder
    private func landscapeLayout(boardSize: CGFloat) -> some View {
        HStack(spacing: 16) {
            // Left side - board
            VStack {
                ChessBoardView(gameState: gameState, boardSize: boardSize)
            }
            .frame(maxWidth: .infinity)

            // Right side - info and history
            VStack(spacing: 12) {
                headerView

                GameInfoView(gameState: gameState)

                MoveHistoryView(moveRecords: gameState.moveRecords)
                    .frame(maxHeight: .infinity)

                actionButtons
            }
            .frame(width: 280)
            .padding(.vertical)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var headerView: some View {
        HStack {
            Text("Chess")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(textColor)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    @ViewBuilder
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button(action: {
                withAnimation {
                    gameState.newGame()
                }
            }) {
                Label("New Game", systemImage: "arrow.counterclockwise")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Button(action: {
                showResignConfirmation = true
            }) {
                Label("Resign", systemImage: "flag.fill")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.8))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(gameState.isGameOver)
            .opacity(gameState.isGameOver ? 0.5 : 1)
        }
    }

    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    ContentView()
}
