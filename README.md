# DungeonSiegeUnzoom
An AutoHotkey 2 script for Dungeon Siege 1 to mitigate camera collision issues by constantly unzooming.

2 unzoom modes are supported:

- fast: spams mouse wheel down.
- soft: holds the zoom out keyboard key down.

## Installation

You can run the script from anywhere, as long as `DungeonSiegeUnzoom.ini` is in the same directory. All keys are configurable in the config file.

## Usage

The hotkeys will only be active when the Dungeon Siege window is active. By default, automatic unzoom will disengage when pressing one of the customizable hotkeys below.

Make sure your hotkeys are the same than the ones in-game.

If the game is run as admin, you must also run the script as admin for hotkeys to work.

> [!CAUTION]
**Do NOT remap mouse wheel up/down as that's the only way to get a fast unzoom!**

## Default hotkeys (see [KeyList](https://www.autohotkey.com/docs/v2/KeyList.htm))

- `j`: open the journal  
- `Tab`: open the map  
- `Escape`: open the menu  
- `F10`: open the game options  
- `-`: zoom out  
- `=`: zoom in  
- `WheelDown`: zoom out  
- `WheelUp`: zoom in  
- `XButton1`: toggle unzoom on and off  
- `XButton2`: switch between soft and fast unzoom modes  

## Hard-coded hotkeys

- `CTRL + Left ALT + F10`: close the script  
- `CTRL + Left ALT + F11`: reload the script  
- `CTRL + Left ALT + F12`: suspend the script (disables all hotkeys)

Default in-game hotkeys:

<img width="840" height="571" alt="image" src="https://github.com/user-attachments/assets/6d70c2d9-b631-4565-8359-6c71636f7811" />

## Limitations

Tooltips do not work while running the game in exclusive fullscreen mode. They are always on top by design so they were disabled to avoid the game tabbing out. The algorithm used to detect if the game is fullscreen is also rudimentary and may fail if the game is not on the primary monitor or running in borderless fullscreen mode.
