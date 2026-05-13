# Match 3

A tile-matching puzzle game built with [LÖVE (Love2D)](https://love2d.org/), featuring colorful tiles, multiple levels, score goals, and a countdown timer.

---

<!-- Replace the line below with your screenshot: ![Banner](docs/banner.png) -->
> 📷 **Add a banner image here:** `![Banner](docs/banner.png)`

---

## Table of Contents

- [Overview](#overview)
- [Screenshots](#screenshots)
- [Gameplay](#gameplay)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Controls](#controls)
- [Game States](#game-states)
- [Architecture](#architecture)
- [Credits](#credits)

---

## Overview

Match 3 is a classic tile-swapping puzzle game. Swap adjacent tiles to create horizontal or vertical matches of 3 or more. Clear matches to score points, meet the level goal before the timer runs out, and advance to the next level.

---

## Screenshots

### Start Screen
<!-- Replace with your actual screenshot: ![Start Screen](docs/start-screen.png) -->
> 📷 **Add start screen screenshot here:** `![Start Screen](docs/start-screen.png)`

### Gameplay
<!-- Replace with your actual screenshot: ![Gameplay](docs/gameplay.png) -->
> 📷 **Add gameplay screenshot here:** `![Gameplay](docs/gameplay.png)`

### Game Over
<!-- Replace with your actual screenshot: ![Game Over](docs/game-over.png) -->
> 📷 **Add game over screenshot here:** `![Game Over](docs/game-over.png)`

---

## Gameplay

- The board is an **8×8 grid** of colored tiles.
- Select a tile and swap it with an adjacent tile to form a match of **3 or more** of the same color.
- Matched tiles are removed, remaining tiles fall down, and new tiles fill the gaps.
- Each level has a **score goal** — reach it before the **timer** hits zero to advance.
- Special match lengths trigger bonus effects:
  - Match of **4** → entire row/column cleared
  - Match of **5** → all tiles of that color cleared
  - Match of **6+** → 32 random tiles cleared from the board

---

## Project Structure

```
match3/
├── main.lua                  # Entry point, window setup, global state
├── src/
│   ├── Dependencies.lua      # Requires all libraries and modules
│   ├── Board.lua             # Board logic: tile init, match detection, falling tiles
│   ├── Tile.lua              # Individual tile rendering
│   ├── Util.lua              # Quad generation and debug utilities
│   ├── StateMachine.lua      # Finite state machine
│   ├── class.lua             # OOP class utility
│   └── states/
│       ├── BaseState.lua     # Base state with empty method stubs
│       ├── StartState.lua    # Title/menu screen
│       ├── BeginGameState.lua# Level transition animation
│       ├── PlayState.lua     # Core gameplay
│       └── GameOverState.lua # End screen
├── graphics/
│   ├── match3.png            # Tile sprite atlas
│   └── background.png        # Scrolling background
├── sounds/
│   ├── music3.mp3
│   ├── select.wav
│   ├── error.wav
│   ├── match.wav
│   ├── clock.wav
│   ├── game-over.wav
│   └── next-level.wav
└── font/
    └── font.ttf
```

---

## Installation

### Prerequisites

- [LÖVE 11.x](https://love2d.org/) installed on your system.

### Running the Game

```bash
# Clone the repository
git clone https://github.com/yourusername/match3.git
cd match3

# Run with LÖVE
love .
```

On Windows you can also drag the project folder onto the `love.exe` executable.

---

## Controls

| Key | Action |
|---|---|
| `Arrow Keys` | Move the cursor |
| `Enter` / `Return` | Select / confirm swap |
| `Escape` | Quit the game |

---

## Game States

The game uses a finite state machine with four states:

| State | Description |
|---|---|
| `StartState` | Animated title screen with Start and Quit options |
| `BeginGameState` | Level intro animation, initialises the board |
| `PlayState` | Main gameplay loop — input, swapping, match resolution |
| `GameOverState` | Displays final score, prompts to return to start |

---

## Architecture

### Board (`Board.lua`)

Manages the tile grid, match detection, and tile-fall physics.

- `initializeTiles()` — fills the 8×8 grid, re-rolls if matches exist at start
- `calculateMatches()` — scans rows and columns for runs of 3+ matching colors
- `removeMatches()` — nils out matched tile positions
- `getFallingTiles()` — shifts tiles down into gaps, spawns new tiles at the top, and returns a tween table for smooth animation

### Tile (`Tile.lua`)

A simple data + render object. Stores grid position, pixel position, color index, and variety index. Renders with a drop shadow for a subtle 3D effect.

### StateMachine (`StateMachine.lua`)

A lightweight finite state machine. States are registered as factory functions and instantiated on transition. Each state implements `enter`, `exit`, `update`, and `render`.

### Timers

Uses [knife.timer](https://github.com/airstruck/knife) for tweening tile positions and driving the countdown clock.


## Credits

- Built with [LÖVE](https://love2d.org/)
- OOP via [hump/class](https://github.com/vrld/hump)
- Tweening via [knife](https://github.com/airstruck/knife)
- Scaling via [push](https://github.com/Ulydev/push)