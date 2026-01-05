# UI Positions for Chess App (iPhone 17 Pro)

## IMPORTANT: Coordinate Mapping Notes

The IDB tap coordinates don't map linearly to screen positions as expected.
Through empirical testing, the following was discovered:

### Verified Working Coordinates
| Element | Tap Position (x, y) | Status |
|---------|---------------------|--------|
| e2 pawn | (238, 665) | ✅ VERIFIED - selects e2 |
| d2 pawn | (192, 685) | ✅ VERIFIED - selects d2 |
| b2 pawn | (100, 685) | ✅ VERIFIED - selects b2 |

### e2 Square Bounds (experimentally determined)
- Tapping y=620 to y=720 at x=238 all select/interact with e2
- Tapping y=580 at x=238 misses the board (no selection)
- This suggests squares are larger than calculated, or coordinate mapping is non-linear

### Known Issues
- Calculated square size (46 points) doesn't match observed behavior
- Moving pieces requires tapping on legal move squares, but coordinate mapping makes this difficult
- The theoretical positions below may not work for automated tapping

---

## Screen Dimensions
- Device: iPhone 17 Pro simulator
- Screenshot pixel size: 1206 x 2622 pixels
- Logical point size: 402 x 874 points (3x scale)

## Chess Board (Theoretical - Use with Caution)
- **Board left edge**: ~16-31 points (estimated)
- **Board size**: ~368 points (46 points per square theoretical)
- **Square size**: ~46 x 46 points (theoretical)

### Theoretical Square Calculation Formula
```
X = 31 + ((file_index + 0.5) * 46)
Y = board_top + ((row_index + 0.5) * 46)
```

Where:
- file_index: 0=a, 1=b, 2=c, 3=d, 4=e, 5=f, 6=g, 7=h
- row_index: 0=rank 8 (black back), ..., 7=rank 1 (white back)

### File X Positions (Verified via Selection)
| File | File Index | X Position (center) |
|------|------------|---------------------|
| a    | 0          | ~54                 |
| b    | 1          | ~100 ✅             |
| c    | 2          | ~146                |
| d    | 3          | ~192 ✅             |
| e    | 4          | ~238 ✅             |
| f    | 5          | ~284                |
| g    | 6          | ~330                |
| h    | 7          | ~376                |

### Rank 2 Y Position (White Pawns) - VERIFIED
- Y position for selecting white pawns: 665-685 works
- e2 pawn center: approximately (238, 665)
- d2 pawn center: approximately (192, 685)

### Key Piece Positions (Starting Position)

#### White Pieces (Rank 1 and 2) - Partially Verified
| Square | Position (x, y) | Verified |
|--------|-----------------|----------|
| a2 (Pawn) | (54, 665-685) | Estimated |
| b2 (Pawn) | (100, 665-685) | ✅ |
| c2 (Pawn) | (146, 665-685) | Estimated |
| d2 (Pawn) | (192, 665-685) | ✅ |
| **e2 (Pawn)** | **(238, 665)** | ✅ VERIFIED |
| f2 (Pawn) | (284, 665-685) | Estimated |
| g2 (Pawn) | (330, 665-685) | Estimated |
| h2 (Pawn) | (376, 665-685) | Estimated |

## UI Buttons
| Element | Position (x, y) | Notes |
|---------|-----------------|-------|
| "New Game" button | (~100, ~820) | Blue button, left side |
| "Resign" button | (~300, ~820) | Red button, right side |

## Troubleshooting Tap Coordinates

If taps aren't working:
1. Selection works reliably for white pawns at y≈665-685
2. Deselection works by tapping same piece again
3. Moving to legal squares requires finding correct Y coordinates
4. Try increments of ±10-20 points to find the right position
5. The board's Y coordinate range is approximately 580-720+ based on testing
