# TDSmacro - Tower Defense Simulator Macro Framework

A modular, reusable scripting framework written in **AutoHotkey v2** for creating custom game macros in **Tower Defense Simulator (TDS)** on Roblox.

Instead of writing macro logic from scratch for every new strategy, **TDSmacro** provides a high-level API to handle camera calibration, tower placement with human-like click noise, upgrading, Discord status updates (with screenshots), map voting, modifier selection, and automated game recovery (rejoining Roblox on disconnects or hangs).

---

## Features

- **Noisy Clicks**: Tower placements (`canplace`) and selection (`selecttower`) use random offsets to avoid avatar idle animation noise.
- **Discord Webhook Integration**: Auto-posts text updates and full-screen screenshots directly to a Discord channel when games finish (Triumph/Loss), when disconnected, or when recovering.
- **Auto-Calibrate Camera**: Standardizes camera zoom and tilt to ensure reliable coordinates.
- **Wave Auto-Skip**: Detects and clicks the skip wave button automatically.
- **Map & Modifier Support**: Auto-searches and votes for specific maps, and supports voting for match modifiers (e.g. Hidden Enemies, Glass, Exploding Enemies, etc.).
- **Automatic Disconnect/Hang Recovery**: If Roblox disconnects or the game gets stuck, the framework automatically uses the Roblox protocol URI to restart the client, re-enter TDS, navigate to the correct gamemode elevator, and launch a new match solo.

---

## Directory Structure

```
tdsmacro-oss/
├── dependencies/               # External AHK dependencies/libraries
│   ├── FindText.ahk            # Core FindText library (yeah that one from feiyue) for screen/image detection
│   ├── OCR.ahk                 # Core OCR library (also yeah that one from descolada) for optical character recognition
│   └── TDSmacro.ahk            # The main reusable framework class
├── config.example.ini          # Settings template (copy to config.ini if theres anything missing there)
├── config.ini                  # Main configuration file
├── LICENSE                     # MIT License
├── README.md                   # Project documentation
├── tdshcmacrov2.ahk            # Example strategy (Hardcore Gem grind and evolved tower xp grind)
└── tdsmacrocoinTRIUMPHyipee.ahk # Example strategy (Coin farming on Black Spot Exchange)
```

---

## Getting Started

### 1. Prerequisites
- **AutoHotkey v2**: Ensure you have [AutoHotkey v2.0+](https://www.autohotkey.com/) installed on your computer.
- **Roblox Resolution**: The image detection and click coordinates are designed around a standard **1080p display (1920x1080), 100% Scale, Disable automatically hide taskbar, Maximized window mode**.

### 2. Configuration Setup
To prevent committing private details like Discord webhooks to public repositories, configuration settings are kept in `config.ini` which is ignored by Git.

1. Duplicate `config.example.ini` and rename the copy to `config.ini`.
2. Open `config.ini` in a text editor and customize the settings:
   ```ini
   [Settings]
    # Paste your Discord Webhook URL here to get status updates and screenshots
    DiscordWebhook=
    # Set to true to print debug messages to Discord/console
    Debug=false
    # If a loop lasts longer than this duration (in seconds), the macro will automatically rejoin
    DefaultPatience=150
    # How many losses before the macro automatically rejoins to try again
    Giveuptolarance=2
    # below is for how much times does it checks that your tower has been placed/selected before restarting the loop (increase if you had higher ping)
    IterativeReads=5
    # new version for level checking, set to false if you wanna use the legacy kinda broken version
    UseOCR=true
   ```

### 3. Writing Your First Strategy
Create a new `.ahk` script in the directory (e.g. `my_strat.ahk`) and structure it like this:

```autohotkey
#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\dependencies\FindText.ahk
#Include %A_ScriptDir%\dependencies\TDSmacro.ahk

; Set up click modes
SendMode "Event"
SetDefaultMouseSpeed 4
CoordMode "Mouse", "Window"

; Define hotkeys
F1::StartMacro()
F3::ExitApp()

StartMacro() {
    while (true) {
        TDSmacro.lost := false
        
        ; 1. Wait for match start and click Ready
        TDSmacro.clickready()
        
        ; 2. Calibrate camera zoom/tilt
        TDSmacro.CalibrateCam()
        
        ; 3. Place a tower using key slot "1" at (X=1000, Y=500)
        TDSmacro.canplace(1000, 500, "1")
        
        ; 4. Select the tower and upgrade it until Level 3 is reached
        TDSmacro.selecttower(1000, 500)
        TDSmacro.upgradeuntil(3) ; Levels 1-7 mapped in TDSmacro.levels
        
        ; 5. Await game finish and press Play Again
        TDSmacro.restartonlost()
    }
}
```

---

## API Reference

### Configuration Properties
- `TDSmacro.debug` *(Boolean)*: Enables verbose logging to your Discord Webhook.
- `TDSmacro.patience` *(Integer)*: Timeout threshold in seconds before assuming the script is stuck and rejoining.
- `TDSmacro.goal` *(String)*: Current target game outcome (`"Triumph"` or `"Lose"`).
- `TDSmacro.map` *(String)*: Target map to search and vote for.
- `TDSmacro.modifiersarrayinput` *(Array)*: Modifiers to enable during the vote.

### Core Methods
- `TDSmacro.clickready()`: Blocks execution until the game starts, finding and clicking the Ready button.
- `TDSmacro.CalibrateCam()`: Resets the camera orientation and zooms all the way out.
- `TDSmacro.canplace(x, y, hotkey)`: Selects slot matching `hotkey` (e.g. `"1"`), attempts to place it at `(x, y)`, adjusting randomly with noise if placement is blocked, and waits until placement succeeds.
- `TDSmacro.selecttower(x, y)`: Selects a placed tower at `(x, y)`.
- `TDSmacro.upgradeuntil(level)`: Upgrades the currently selected tower continuously until it matches the visual level index.
- `TDSmacro.restartonlost()`: Detects a Triumph or Game Over, logs details / takes a screenshot, clicks "Play Again", and handles map voting/modifiers on game loop.
- `TDSmacro.rejoin()`: Launches Roblox from clean state, navigates elevators, configures the matching mode, and sets up a new game.

---

## Contributing & Security

- **Do not commit `config.ini`**: It contains your private Discord webhooks. The project is pre-configured with a `.gitignore` to prevent this.
- If you add support for new maps or modifiers, please update the internal lists inside `TDSmacro.ahk`.

## License

This project is licensed under the MIT License - see the [LICENSE](file:///C:/Users/guesswho/Desktop/ahk%20macros/tdsmacro-oss/LICENSE) file for details.
