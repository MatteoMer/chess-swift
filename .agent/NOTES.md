# Development Notes

## 2026-01-05

### Initial Assessment
- Fresh SwiftUI project with basic boilerplate
- No existing chess logic or UI
- Need to implement full chess game from scratch

### Design Decisions
1. **Architecture**: Using MVVM pattern with SwiftUI
2. **Piece Rendering**: Using SF Symbols for chess pieces (chess.* symbols available in iOS 14+)
3. **State Management**: Using @Observable class for game state
4. **Board Orientation**: White always at bottom (rows 0-1 for black, rows 6-7 for white in internal representation)

### Technical Notes
- iOS 14+ has chess SF Symbols: chess.king, chess.queen, chess.rook, chess.knight, chess.bishop, chess.pawn
- These can be filled for one color and outlined for the other
