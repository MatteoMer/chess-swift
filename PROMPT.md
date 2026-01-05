Your job is to implement a local multiplayer chess app for iOS.

The app allows two players to play chess on the same device, taking turns. There is no AI opponent—this is purely for two humans sitting together.
Whenever the game logic is done, you must focus on making a beautiful and modern UI and design. The goal is to have a polished and well-made app.

CORE FEATURES:

**Chess Board**
- Standard 8x8 chess board with alternating light and dark squares
- Pieces displayed using standard chess iconography
- Board orientation stays fixed (white at bottom)
- Clear visual distinction between piece colors

**Game Mechanics**
- Full standard chess rules implementation
- Legal move validation for all piece types (pawn, rook, knight, bishop, queen, king)
- Special moves: castling (kingside and queenside), en passant, pawn promotion
- Turn-based play alternating between white and black
- Check and checkmate detection
- Stalemate detection
- Move highlighting (show legal moves when a piece is selected)

**Piece Interaction**
- Tap to select a piece
- Tap destination square to move
- Visual feedback for selected piece
- Highlight available legal moves for selected piece
- Clear indication of whose turn it is

**Game State**
- Display current player's turn prominently
- Show captured pieces for each side
- Check indicator when a king is in check
- Game over screen for checkmate, stalemate, or resignation
- Option to resign
- Option to start a new game

**Move History**
- Display list of moves in standard algebraic notation
- Scrollable move history panel

**Visual Polish**
- Clean, modern iOS design
- Smooth animations for piece movement
- Haptic feedback on piece placement
- Support for both light and dark mode

VISUAL VERIFICATION WORKFLOW:
This is critical for iOS development. After making UI changes, ALWAYS verify visually:

1. Build and run the app:
   xcodebuild -scheme {SCHEME_NAME} -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build
   xcrun simctl launch booted {BUNDLE_ID}

2. Take a screenshot to verify:
   python -m ralph.simulator screenshot --context "description of expected screen" --json

3. Use the Read tool on the screenshot path to analyze visually.
   You can see the UI and determine if it matches your expectations.

4. If you need to navigate to a different screen:
   - Analyze the screenshot to find buttons/elements
   - Estimate coordinates (e.g., "Login button appears at ~200, 600")
   - Tap: python -m ralph.simulator tap --x 200 --y 600
   - Screenshot again to verify navigation worked

5. Document observations in .agent/NOTES.md

6. Whenever you encounter a new position (a new button, a piece, text, ...) that might be useful in the future, document it in .agent/POSITIONS.md

PROACTIVE SCREENSHOTS:
Take screenshots at these key moments:
- After building the app (verify it launched correctly)
- After making UI changes (verify layout matches intent)
- When debugging visual issues (see current state)
- After fixing UI bugs (confirm the fix)
- Before committing UI-related changes (final verification)

SIMULATOR COMMANDS:
```bash
# Screenshot
python -m ralph.simulator screenshot --context "..." --json

# Tap at coordinates
python -m ralph.simulator tap --x 200 --y 400

# Swipe/scroll
python -m ralph.simulator swipe --from 200,800 --to 200,200

# Type text
python -m ralph.simulator type "text to enter"

# Press home button
python -m ralph.simulator button home

# Check status
python -m ralph.simulator status --json
```

DEVELOPMENT PRIORITIES:
1. Understand the existing codebase structure
2. Plan the implementation approach
3. Implement incrementally with commits
4. Verify each UI change visually
5. Write/update tests as needed
6. Ensure the app builds and runs correctly

Use the .agent/ directory for tracking:
- .agent/TODO.md for current tasks
- .agent/PLAN.md for implementation plan
- .agent/NOTES.md for observations and decisions
- .agent/screenshots/ for UI verification screenshots

Make a commit and push your changes after every meaningful edit.
