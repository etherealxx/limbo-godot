<table>
  <tr>
    <td style="width:50%">
      <img src="https://github.com/etherealxx/limbo-godot/assets/64251396/3524c12c-64b5-48c3-88bd-f1c340db9c1b" alt="focus" style="max-width:100%;">
    </td>
    <td style="width:50%">
      <h3>A window-based, LIMBO-inspired, key-shuffle minigame made with Godot Engine, for Windows Desktop</h3>
    </td>
  </tr>
</table>

<!-- ![altgithub-ezgif com-resizex](https://github.com/etherealxx/limbo-godot/assets/64251396/3524c12c-64b5-48c3-88bd-f1c340db9c1b) -->

---

![limboscene9](https://github.com/etherealxx/limbo-godot/assets/64251396/2c1dee2c-2fd5-4519-8c22-ed08960f55d5)

---

#### For Godot User
- Clone this repo locally
- Open the project with `Godot 4.2.1`, and then open main scene (`"res://scenes/main.tscn"`)
- Follow the instruction provided there

#### Tips for player
- When running the game, when all the 8 key is shown, before it starts shuffling, you could double right click at any of the key, the game will close and then being replaced with a setting menu.
- You can adjust several toggles on the setting menu, some of the useful one are:
  - `transparent_background`, when turned off, the keys' window will no longer be transparent. Improves performance on lower end devices
  - `music_volume`, adjust the volume. Default is 20. Decreasing it will decrease the volume by 1 dB each.
  - `no_ending_screen`, when turned on, the bluescreen sequence won't happen, instead after clicking on the key, it'll just say if the key you choose is correct or wrong. For quick play.
  - `fullscreen_ending`, when turned off, the ending sequence will play on maximized borderless window. This can fix some recording software can't properly record the ending sequence transition.
  - The rest are useful for debugging, and information about each variable can be read on the main root node's [script](https://github.com/etherealxx/limbo-godot/blob/master/scripts/main.gd).
- Pressing `Esc` during the bluescreen ending will make you instantly quit the game, instead of needing to wait for 7 seconds

#### Tips for developer
- Before exporting, make sure every exported variable of `main.tscn` is set to default, by checking the Inspector tab and pressing every reset button on the `main.gd` section. Unless you want to set the changed value as the default for the exported executable.
- Using the custom built export template could save the executable size by roughly 45%. Check it on the Release page.
- I exported the executable with encryption, the preset is already on the export template, just turn it on. But make sure if you also want to do it, make the export template by yourself. More info [here](https://docs.godotengine.org/en/stable/contributing/development/compiling/compiling_with_script_encryption_key.html).
- The save file is located in `%appdata%\limbo-godot\limbosave.cfg`, while the log file is on `%appdata%\limbo-godot\logs\limbo.log`.
- `toggleaddons.gd` is an editorscript, located in `res://scripts/editorscript`. It can be run by opening it on the script editor then pressing File > Run (or `Ctrl+Shift+X`). Running it will turn off every addons i currently use. I use it to exclude addons before exporting the project and pushing it into Github. You need to reload the project immediately after running the script. It was designed to be a toggle of some sort, so if the addon was deactivated before, the next time you run the script, it'll be activated again, and vice versa.

#### Known Bugs

- The game won't work on device with vertical (portrait) primary monitor.
- There's a weird bug in certain Windows 10 device, where the black part of the ending sequence is fully transparent, and the bluescreen is half transparent.
- You can run the executable again to launch another game while the game is still running.
- The game will look a bit weird on device with monitor resolution/display height smaller than +-900px
- The song will desync when running the game on low-end device
- The transition between choosing the key and the ending scene may freeze screen recorder (the recording will still going but the recorded video will looks weird). <br/>This can be mitigated by setting `fullscreen_ending` to `off` and `hide_title_on_maximize` to `on`. 
- The blue pattern background on the ending scene may look cutted on certain device with higher resolution

---

### Credits
- [Isolation](https://www.youtube.com/watch?v=O07SX0BliAQ) by Nighthawk22 (Song used for LIMBO)
- Level complete/death sfx, spike and background sprite ripped from Geometry Dash by RobTop
- [Windows 11 icon pack](http://www.rw-designer.com/icon-set/windowsicons-zip) by rw-designer for the This PC icon
- Mindcap & more for the original LIMBO level in Geometry Dash
- [Selawik](https://github.com/microsoft/Selawik) and Segoe Boot Semilight by Microsoft
- Zylann for the original [change color shader](https://forum.godotengine.org/t/changing-a-specific-color-in-a-sprite-using-shaders-in-godot-3/29610/4) on Godot forum
- Godot Engine by Juan Linietsky, Ariel Manzur & Contributors <br/>(License: https://godotengine.org/license/)

### Special Thanks
- Thanks to the maker of addons that I use during the development of this game, which are [script-ide](https://github.com/Maran23/script-ide) and [discord-rpc-godot](https://github.com/vaporvee/discord-rpc-godot). Both are amazing
- quasar098's [limbos32](https://github.com/quasar098/limbos32) as my main inspiration of this project, and this repos was the fork of that. Though it changed so much that the only thing left is only the `key.png`
- MarkHermy3100's [LimboKeys](https://github.com/MarkHermy3100/LimboKeys) as i use his [key shuffler](https://github.com/MarkHermy3100/LimboKeys/blob/main/assets/scripts/Shuffler.ts) pattern. It's near accurate, and it's vertical (4 rows 2 columns just like the original LIMBO)
- enderprism for his sprite rip from [godot-dash-v2](https://github.com/enderprism/godot-dash-v2)
- The entire [Godot Official Discord Server](https://discord.com/invite/zH7NUgz), especially those who always helps me when i asks questions😊
