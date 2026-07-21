# TDSmacro.ahk - Tower Defense Simulator Macro class

A modular, reusable scripting framework written in **AutoHotkey v2** for creating custom game macros in **Tower Defense Simulator (TDS)** on Roblox.  

You ever want to Build your own **Macro?**🤔  
Well You can cheer now BECAUSEEEE❓  
well.... **TDSmacro** Module **EXISTT**🎉  
You now dont have to build macro from scratch ✨  
**TDSmacro** Provides some handy feature such as Noisy Clicks, Camera Calibration, Automatic Skip without vip, Discord Webhook Integration and Much more  
Wanna know the detail?? just scroll down bruh  
Btw check [@noskilluser](https://www.youtube.com/@noskilluser) channel for TDSmacro Discord Server  

---

## Features

- **Noisy Clicks**: When placing and selecting tower using (`PlaceTower()`) And (`TowerSelect()`) use random offsets to avoid avatar idle animation noise. Basically if the macro failed to place, it search for random available position.
- **Discord Webhook Integration**: Send Match Results directly into your discord channel. When Triumph or Loss. If debug were enabled, it will give more detailed information.
- **Auto-Calibrate Camera**: Standardizes camera zoom and tilt to ensure reliable coordinates.
- **Wave Auto-Skip**: It will detect Skip button and Click it automatically. Why buy VIP when you have this?🤑
- **Map & Modifier Support**: Auto-searches and votes for specific maps, and supports voting for match modifiers (e.g. Hidden Enemies, Glass, Exploding Enemies, etc.).
- **Automatic Disconnect/Hang Recovery**: Bad Internet? LOL. No worries, because **TDSmacro** can automatically rejoin/run Roblox for you if your wifi sometimes in bad mood.

---

## Directory Structure

```
tdsmacro-oss/
├── dependencies/                    # External AHK dependencies/libraries
│   ├── FindText.ahk                 # FindText library (yeah that one from feiyue) for screen/image detection
│   ├── OCR.ahk                      # OCR library (also yeah that one from descolada) for optical character recognition
│   ├── ImagePut.ahk                 # For processing image (mainly for rapidocr)
│   ├── TDSmacro.ahk                 # The main class for this repo
│   ├── Webhook.ahk                  # eh just to send discord webhooks
│   ├── models/                      # .ONNX models for rapidocr
│   └── bin/                         # Dll libraries for rapidocr
├── config.example.ini               # Settings template (copy to config.ini if theres anything missing there)
├── config.ini                       # Main configuration file
├── LICENSE                          # MIT License
├── README.md                        # Project documentation
└── Strategies/                      # Example Strategies
    ├── MILITANT_COIN_TRIUMPH.ahk    # Example 1 (Coin farming on Dead ahead with No special towers)
    ├── PYRO_SNIPER_GEM.ahk          # Example 2 (Hardcore Gem grind and evolved tower xp grind with No special towers)
    ├── PYRO_ENGI_GEM.ahk            # Example 3 (Hardcore Gem grind and evolved tower xp grind)
    ├── BRAWLER_COIN_LOSE.ahk        # Example 4 (VIP-less coin grind on Winter bridges)
    └── GSOLDIER_COIN_TRIUMPH.ahk    # Example 5 (Coin farming on Dead ahead)
```

---

## Getting Started

### 1. Prerequisites
- **AutoHotkey v2**:MAKE SURE, MAKE SURE YOU HAVE[AutoHotkey v2.0+](https://www.autohotkey.com/) installed on your computer. Or else the macro will be crippled into `.txt` (source: trust me bro)
- **Settings Needed**:The Image/Text Detection Search Field and click coordinates are designed around:  
**1080p display (1920x1080), 100% Scale, Disable automatically hide taskbar, Maximized windowed mode**. 
For TDS Roblox Settigs you have to activate:  
**Prefer Vertical Upgrades off, Tower 1 2 3 4 5 6 using Keybind 1 2 3 4 5 6, Upgrade tower keybind using E**  
Unless you want your macro have seizure and then die. **ACTIVATE THEM**
- **Resolution and Scale**:  
  
  ![Display Settings](https://media.discordapp.net/attachments/1123983797378101370/1528067875263479969/image.png?ex=6a5cf39b&is=6a5ba21b&hm=e7e62d454e2ebea86dcaee1eb3b6e2a4333d9130d69f975a05922a4152e21030&=&format=webp&quality=lossless&width=1583&height=188)  

- **Show Taskbar Setting**:  
  
  ![Taskbar Settings](https://media.discordapp.net/attachments/1123983797378101370/1528067911049154570/image.png?ex=6a5cf3a4&is=6a5ba224&hm=38dc3d6fa40976cae4e5c73693fec32ac924060948d9d5d2a464688b1ae15d74&=&format=webp&quality=lossless&width=566&height=209)

- **Vertical Upgrades**:  

  ![Vertical Upgrades](https://media.discordapp.net/attachments/1123983797378101370/1528067958713090119/image.png?ex=6a5cf3af&is=6a5ba22f&hm=be7088813c73fdfaf8e8fd93af956e94cb8b1c7020e2ba6a7ccb718d671f8910&=&format=webp&quality=lossless&width=810&height=128)

- **Tower Keybinds**:  

  ![Tower Keybids](https://media.discordapp.net/attachments/1123983797378101370/1528068007555891230/image.png?ex=6a5cf3bb&is=6a5ba23b&hm=c99bf2f44694fbd6d42afd3c44adca6b885620655eb2d0e773c0a558c8972492&=&format=webp&quality=lossless&width=733&height=210)

-**Upgrade Tower Keybind**:  

  ![Upgrade Keybind](https://media.discordapp.net/attachments/1123983797378101370/1528068051143233727/image.png?ex=6a5cf3c5&is=6a5ba245&hm=9a1c442e3fac99300c83362f8a615c12c0a4043992f073e9602e550c3d23e2aa&=&format=webp&quality=lossless&width=638&height=150)


### 2. Configuration Setup
To prevent committing private details like Discord webhooks to public repositories, configuration settings are kept in `config.ini` which is ignored by Git.

1. See `config.example.ini` as a schema for `config.ini`.
2. Open `config.ini` in a text editor and customize the settings:
   ```ini
   [Settings]
    # Paste your Discord Webhook URL here to get status updates and screenshots
    DiscordWebhook=
    # Set to true to print debug messages to Discord/console and activate Search Field visibility
    Debug=false
    # If a loop lasts longer than this duration (in seconds), the macro will automatically rejoin
    DefaultPatience=180
    # How many losses before the macro automatically rejoins to try again (if goal is to Triumph)
    Giveuptolarance=2
    # below is for how much times does it checks that your tower has been placed/selected before restarting the loop (basically increase if you had higher ping)
    IterativeReads=5
    # below if you want your macro to use timescale, i dont really recommend if you use exploding enemies modifiers or just a laggy gameplay
    UseTimescale=false
    # keep your tickets above this certain limit
    TimescaleUntil=1
    # new version for level checking, set to false if you wanna use the legacy kinda broken version
    UseOCR=true
    # error tolarance default for Findtext.ahk
    PixelConfidence=0.05
    ColorConfidence=0.05
   ```

### 3. Writing Your First Strategy
Create a new `.ahk` script in the directory (e.g. `my_strat.ahk`) and structure it like this:

```autohotkey
#Requires AutoHotkey v2.0
#Include *i %A_ScriptDir%\dependencies\TDSmacro.ahk
#Include *i %A_ScriptDir%\..\dependencies\TDSmacro.ahk
SendMode("Event")
SetDefaultMouseSpeed(4)
CoordMode("Mouse", "Window")

F1::{
    while (true) {
        TDSmacro.StartMatch()

        /*insert strat here for example

        TDSmacro.PlaceTower(920,500,"1",600) x,y, keybind, price
        TDSmacro.UpgradeUntilLevel(4) upgrades a tower until it rearches that lvl
        Click(100,100) example you just selected another tower
        TDSmacro.TowerSelect(920,500) tries to select a tower on that location x,y
        */

        TDSmacro.RestartMatch()
    }
}

F2::TDSmacro.CalibrateCamera()
F3::ExitApp()
```

---

## API Reference and Important function
**I mean very very very important**
### Configuration Properties
- `TDSmacro.debug` *(Boolean)*: Enables sending chats beside result into your discord channel.
- `TDSmacro.patience` *(Integer)*: Timeout threshold in seconds before assuming the script is a broken boi and rejoining.
- `TDSmacro.goal` *(String)*: Current target game outcome (`"Triumph"` or `"Lose"`).
- `TDSmacro.map` *(String)*: Target map to search and vote for.
- `TDSmacro.modifiersInput` *(Array)*: Select which modifiers to enable during the vote.

### Core Methods
- `TDSmacro.StartMatch()`: Blocks execution until the game starts, finding and clicking the Ready button.
- `TDSmacro.CalibrateCamera()`: Resets the camera orientation and zooms all the way out.
- `TDSmacro.PlaceTower(x, y, hotkey, price)`: Selects slot matching `hotkey` (e.g. `"1"`),wait for `price` attempts to place it at `(x, y)`, adjusting randomly with noise if placement is not available, and waits until placement succeeds.
- `TDSmacro.TowerSelect(x, y)`: Selects a placed tower at `(x, y)`.
- `TDSmacro.UpgradeUntilLevel(level)`: Upgrades the currently selected tower continuously until it matches the level you want.
- `TDSmacro.RestartMatch()`: Detects a Triumph or Game Over, logs details / takes a screenshot, send it to Discord channel, clicks "Play Again", and handles map voting/modifiers on game loop.
- `TDSmacro.Rejoin()`: Launches Roblox from clean state, select mode, difficulty, and restart your game loop.

---

## Contributing & Security

- **Do not commit `config.ini`**: It contains your private Discord webhooks. The project is pre-configured with a `.gitignore` to prevent this.
- If you add support for new maps or modifiers, please update the internal lists inside `TDSmacro.ahk`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
