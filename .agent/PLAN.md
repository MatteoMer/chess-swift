# Chess App Implementation Plan

## Overview
Implementing a local multiplayer chess app for iOS with SwiftUI. The app allows two players to play chess on the same device, taking turns.

## Architecture

### Model Layer
1. **Piece.swift** - Enum for piece types (pawn, rook, knight, bishop, queen, king) and colors (white, black)
2. **Position.swift** - Struct for board positions (row, column)
3. **Move.swift** - Struct representing a move with source, destination, and special move types
4. **Board.swift** - Struct representing the 8x8 board state
5. **GameState.swift** - Observable class managing the entire game state

### View Layer
1. **ChessBoardView.swift** - Main chess board rendering
2. **SquareView.swift** - Individual square on the board
3. **PieceView.swift** - Visual representation of pieces
4. **GameInfoView.swift** - Turn indicator, captured pieces, check status
5. **MoveHistoryView.swift** - Scrollable list of moves in algebraic notation
6. **GameOverView.swift** - Game over modal/sheet
7. **ContentView.swift** - Main container view

### Logic Layer
1. **MoveValidator.swift** - Legal move validation for all piece types
2. **CheckDetector.swift** - Check and checkmate detection
3. **NotationConverter.swift** - Convert moves to algebraic notation

## Implementation Order
1. Data models (Piece, Position, Move, Board)
2. Basic game state
3. Move validation (all piece types including special moves)
4. Check/checkmate/stalemate detection
5. Basic UI (board and pieces)
6. Piece interaction (selection, move highlighting)
7. Game info UI
8. Move history
9. Game over screen
10. Animations and haptics
11. Visual polish

## File Structure
```
chess-swift/
├── Models/
│   ├── Piece.swift
│   ├── Position.swift
│   ├── Move.swift
│   └── Board.swift
├── ViewModels/
│   └── GameState.swift
├── Views/
│   ├── ChessBoardView.swift
│   ├── SquareView.swift
│   ├── PieceView.swift
│   ├── GameInfoView.swift
│   ├── MoveHistoryView.swift
│   ├── GameOverView.swift
│   └── ContentView.swift
├── Logic/
│   ├── MoveValidator.swift
│   └── NotationConverter.swift
├── Assets.xcassets/
└── chess_swiftApp.swift
```
