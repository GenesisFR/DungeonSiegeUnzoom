# DungeonSiegeUnzoom
An AutoHotkey 2 script for Dungeon Siege 1 to mitigate camera collision issues by constantly unzooming all the time.

2 unzoom modes are supported:
- fast: spams mouse wheel down.
- soft: holds the zoom out keyboard key down.

## Installation

You can run the script from anywhere, as long as "DungeonSiegeUnzoom.ini" is in the same directory.  

## Usage

The hotkeys will only be active when the Dungeon Siege window is active.

You can edit the script settings in the "DungeonSiegeUnzoom.ini" config file. Please read it for more information about settings.

Make sure your hotkeys are the same than the ones in-game.

If the game is run as admin, you must also run the script as admin for hotkeys to work.

> [!CAUTION]
**Do NOT remap mouse wheel up/down as that's the only way to get a fast unzoom!**

Default customizable hotkeys:

Mouse wheel down: zoom out  
Mouse wheel up: zoom in  
-: zoom out  
=: zoom in  
4th mouse button: toggle unzoom on and off  
5th mouse button: switch between soft and fast unzoom modes  

Hardcoded hotkeys:

CTRL + Left ALT + F10: close the script  
CTRL + Left ALT + F11: reload the script  
CTRL + Left ALT + F12: suspend the script (disables all hotkeys)

Default in-game hotkeys:

<img width="840" height="571" alt="image" src="https://github.com/user-attachments/assets/6d70c2d9-b631-4565-8359-6c71636f7811" />

## Limitations

Tooltips do not work while running the game in exclusive fullscreen mode. They are always on top by design so they were disabled to avoid the game tabbing out. The algorithm used to detect if the game is fullscreen is also rudimentary and may fail if the game is not on the primary monitor or running in borderless fullscreen mode.
