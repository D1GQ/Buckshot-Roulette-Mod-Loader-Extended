# Buckshot Roulette Mod Loader Extended (BRML-E)
A mod loader for **Buckshot Roulette**
---
<img width="1920" height="1080" alt="title-screen" src="/assets/TitleScreen.png" />
<img width="1920" height="1080" alt="mod-list" src="/assets/ModList.png" />

This is the [Godot Mod Loader](https://github.com/GodotModding/godot-mod-loader) patched into Buckshot Roulette. Drop mods in a folder and they load.

## Downloads
Each release includes:
- `BRML-E_Setup.exe` - Windows installer
- `BRML-E_Steam.xdelta` - Patch file

## Installation

### Windows Installer
1. Download `BRML-E_Setup.exe` from [Releases](https://github.com/AGO061/BuckshotRouletteModLoader-Extended/releases)
2. Run the installer
3. Choose where to install (defaults to Desktop\BuckshotRouletteModded)
4. Select your original `Buckshot Roulette.exe` (Steam version) when prompted
5. Select the included `BRML-E_Steam.xdelta` patch file
6. The installer copies all game files and applies the patch
7. Launch from the created shortcut or the modded .exe

### Manual Patching
1. Download `BRML-E_Steam.xdelta`
2. Use xdelta3 to patch your original `Buckshot Roulette.exe`
3. Create a `mods` folder next to the patched .exe
4. The patched .exe will have mod loader support

## Adding Mods
The mod loader recognizes two folders:
- `mods` - Place your mod folders or archives here
- `mods-unpacked` - For manually extracted mods

## Mods
- [Smarter Dealer](https://github.com/ITR13/BuckshotRouletteMods)
- [Challenge Pack](https://github.com/StarPandaBeg/ChallengePack)
- [FullCustomizer](https://github.com/MSLaFaver/BuckshotRouletteMods/releases)
- [KeyboardShortcuts](https://github.com/MSLaFaver/BuckshotRouletteMods/releases)
- [VirtualReality](https://github.com/MSLaFaver/BuckshotRouletteMods/releases)
- [Native Resolution](https://github.com/EmK530/BRMods)

Mods load automatically on startup.

---

*Steam version only. itch.io not supported for now.*
