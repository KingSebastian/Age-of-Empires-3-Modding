# Age of Empires 3 Modding

In this repo we explore a variety of modding concepts from Age of Empires 3 (Vanilla and The Asian Dynasties).

Main topics include:

- Home Cities (editing, unlocking campaign/hidden nations)
- Custom Maps (XS scripting)
- Other experimental modding ideas

This project pulls from various sources (some quite old), so availability may vary over time.

---

## Sources

Here are some useful places to learn more:

- https://aoe3.heavengames.com/modding/tutorials/

---

## Tools

For most basic modding, you only need:

- [Notepad++](https://notepad-plus-plus.org/)

For more advanced mods, these are recommended:

- [Visual Studio Code](https://code.visualstudio.com/)
- [Resource Manager](https://forums.ageofempires.com/t/v-0-5-resource-manager-viewing-comparing-creating-and-extracting-files-from-age-of-empires-iii-bar-archive/103349)
- [SCP Modloader](https://aoe3.heavengames.com/downloads/showfile.php?fileid=3389) (TAD only)
- [AoEed](https://aoe3.heavengames.com/cgi-bin/forums/display.cgi?action=st&fn=1&tn=23622) (Older alternative to `Resource Manger`)

---

## Getting Started

Age of Empires 3 stores files in two main locations:

- USER:  
  `C:\Users\<user>\Documents\My Games\Age of Empires 3`

- SYSTEM:  
  `C:\Program Files (x86)\Microsoft Games\Age of Empires III`

> Note: For the Steam version, system files are typically located in:  
> `C:\Program Files (x86)\Steam\steamapps\common\Age of Empires III`

User files are generally safe to edit. System files can cause version mismatches, so we will mostly limit changes there unless creating full mods.

---

## Homecity

Home Cities are one of the defining features of Age of Empires 3. They add a strategic layer through shipments, decks, and progression.

If you've found a deck online and want to unlock the required cards, this is where to start.

Useful deck resources:

- https://eso-community.net/viewtopic.php?f=29&t=9169
- https://aoe3homecity.com/en/strategies/decks
- https://aoe3explorer.com/decks

---

### Leveling Them Up

You _could_ download max-level Home Cities from community sites, but the goal here is to understand how to do it yourself.

Before starting:

1. Launch the game at least once
2. Create a Home City

Now navigate to: `<USER>\Savegame`

> Note: Even though there is a `Homecities` folder, the game actually stores Home City data in the `Savegame` folder.

Find your file: `sp_<NAME_OF_YOUR_CITY>_homecity.xml`

This file contains:

- City name
- Level
- Skill points
- Decks and cards
- Cosmetics

---

### Editing the File

Open the file using Notepad++ (or any text editor).

Locate:

```xml
<level>1</level>
<skillpoints>0</skillpoints>
```

And change it to:

```xml
<level>131</level>
<skillpoints>131</skillpoints>
```

_Note: In The Asian Dynasties, Home Cities start at level 10, but you can still modify them._

### Result

After saving the file and launching the game:

- Your Home City will be level 131
- All cards will be unlockable
