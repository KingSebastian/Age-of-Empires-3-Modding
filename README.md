# Age of Empires 3 Modding

In this repo, we explore a variety of modding concepts from Age of Empires 3 (Vanilla and The Asian Dynasties).

Main topics include:

- User and System Files (What does/doesn't break multiplayer compatibility)
- Home Cities (editing, unlocking campaign/hidden nations)
- Creating New Hotkeys
- Visual Changes (Colors, architecture)
- Modifying Units
- Custom Maps (XS scripting)
- Other experimental modding ideas

This project pulls from various sources (some quite old), so availability may vary over time.

---

## Index

1. [Tools](#tools)
2. [Getting Started](#getting-started)
3. [USER Files](#user-files)
   1. [Editing Home City Level (and More)](#editing-home-city-level-and-more)
   2. [Unlocking Hidden Civilizations](#unlocking-hidden-civilizations)
   3. [USER Files Troubleshooting](#user-files-troubleshooting)
4. [SYSTEM UI Files](#system-ui-files)
   1. [Editing Player Colors](#editing-player-colors)
   2. [New Hotkeys](#new-hotkeys)
   3. [Alternative UIs](#alternative-uis)
   4. [SYSTEM UI Files Troubleshooting](#system-ui-files-troubleshooting)
5. [SYSTEM Data Files](#system-data-files)
   1. [Editing Civilizations](#editing-civilizations)
   2. [Editing Units (Intro)](#editing-units-intro)
6. [XS Scripting (Custom Maps)](#xs-scripting-custom-maps)
   1. [Basics](#basics)
   2. [Changing Existing Maps](#changing-existing-maps)
   3. [Creating a Custom Map](#creating-a-custom-map)
   4. [Tips and Tricks](#tips-and-tricks)
   5. [Advanced Guide](#advanced-guide)
   6. [XS-Injections](#xs-injections)

## Sources

Here are some useful places to learn more:

- https://aoe3.heavengames.com/modding/tutorials/

---

## Tools

### Basic

- [Notepad++](https://notepad-plus-plus.org/)
  Will be using it to edit `.xml` and `.xs` (similar to C) files with syntax highlighting

### Recommended (Advanced Modding)

- [Visual Studio Code](https://code.visualstudio.com/)
  Better editing experience for large or complex mods, plus you can use extensions for extra features

- [Resource Manager](https://forums.ageofempires.com/t/v-0-5-resource-manager-viewing-comparing-creating-and-extracting-files-from-age-of-empires-iii-bar-archive/103349)
  Used to open and extract files from the `.bar` archive

- [SCP Modloader](https://aoe3.heavengames.com/downloads/showfile.php?fileid=3389) (TAD only)
  Allows loading mods without modifying the base game files

- [AoEed](https://aoe3.heavengames.com/cgi-bin/forums/display.cgi?action=st&fn=1&tn=23622)
  An older alternative to `Resource Manager`.

---

## Getting Started

This guide assumes that you have booted up the game at least once and completed a match. Some minor file deviations might appear if you have never started the game before.

Age of Empires 3 stores files in two main locations:

- USER:  
  `C:\Users\<user>\Documents\My Games\Age of Empires 3`

- SYSTEM:  
  `C:\Program Files (x86)\Microsoft Games\Age of Empires III`

> Note: For the Steam version, system files are typically located in:  
> `C:\Program Files (x86)\Steam\steamapps\common\Age of Empires III`

These two places serve two different purposes. `SYSTEM` files are used to define data that will be loaded at start. `USER` files are used to bundle, group, and keep track of some of that data, including being rewritten by the game. This makes it so that `USER` files are generally safe to edit, as their loss only leads to loss of progress or user configs. `SYSTEM` files, on the other hand, can cause version mismatches or completely break the game, so we will mostly limit changes there. You are also hereby strongly advised to only change files you have read about before.

**AND REMEMBER: ALWAYS BACK-UP EVERYTHING YOU TOUCH!**
_And if you go really deep, use a version manager like Git._

---

## USER Files

As we just saw, USER files are used to keep track of user progress, preferences, and other types of bundlings.

Having in mind the previously defined `USER` folder as root, we would expect a tree structure like this:

```bash
.
├───AI{2,3}
├───campaign
├───Data
├───HomeCities
├───RM{2,3}
├───Savegame
├───Scenario
├───Screenshots
├───Startup
├───Trigger{2,3}
├───Users{2,3}
```

_Note: The `{2,3}` is used to simplify the presence of the expansions._

Of all these folders, some will be of higher importance to us than others, in particular the `RM` and `Savegame` folders. However, I will still briefly walk over each one and explain its usefulness. Feel free to skip to the [first mini project](#editing-home-city-level-and-more).

### USER Files structure

#### AI

Perhaps from the name of this folder, we already have an idea of what is going on. And if we open it up, we will find exactly that. A bunch of personality files (secretly `xml`) that define an AI player profile, including its civilization, behavior settings, and a record of past matches (such as units built, outcomes, and player relationships), which the game uses to influence AI chats.

#### campaign

The name is somewhat self-explanatory, but it only keeps track of decks used at each campaign. It does not keep track of the current mission, the max mission, or even difficulty.

#### Data

Seems to be a dead folder, just mirroring what the `SYSTEM\data\` does

#### HomeCities

This is, unfortunately, a red herring. Developers seem to have intended this folder to hold on to the home cities, but this is not the case. The actual home cities are in `USER\Savegame\`.

#### RM{2,3}

RM stands for Random Maps, and it's simply the place where you can place your custom maps. It also works as a place for the game to drop map dumps into.

#### Savegame

Probably the most important folder, at least for us. Keeps the files regarding Homecities, Savegames, and Recordings

\_Side Note: The game records games as `Record Game {1-9}.age3rec`, by constantly pushing them up and saving the new one as 1. This unfortunately means that old recordings get deleted.

The recordings can only be watched inside the game, and they should not be edited. There are a couple of other tools that can analyse recordings to see who played, who won, which map was played, and which civilizations.
Likewise, I wouldn’t recommend touching the savegames, denoted as `.age3sav` files, unless you intend to paste someone else's files into your folder, or delete some of yours.

The homecity files can be edited heavily and easily. And it will be the subject of our first project, still inside this `USER` files module.

> Note: In general, we will only be editing `.xlm` or `.xs` (similar to C) files.

#### Scenario

Contains your custom scenarios. You can add or delete them from there, but to edit them, use the in-game `Scenario Editor`.

#### Screenshots

Self explanatory.

#### Startup

The `Startup` folder can contain both `.con` and `.cfg` files. The first ones are used to define custom hotkeys, and the latter serve to define launch flags, like no intro cinematics or developer mode.

#### Trigger{2,3}

They are for temporary purposes only and usually contain merely the file "trigtemp.xs". This file is always generated at game start if triggers are used. It contains the XS source code of the trigger functions (XS is a programming/scripting language very similar to the C language).

It's sometimes useful for map/scenario developers to debug trigger problems.

#### Users{2,3}

Also, very important folders, as they contain your profile. This keeps track of various things like settings, campaign progress, and hotkeys.

### Editing Home City Level (and More)

Home Cities, despite being one of the defining features of Age of Empires 3, as they add a strategic layer through shipments, decks, and progression, start in a quite limited state. Their low-level blocks you from unlocking quite a lot of cards, and also reduces your possible age-up politicians. And to make it worse, they are quite slow to level up.

So ff you've found a deck online and want to unlock the required cards, this is where to start.

    Useful deck resources:

    - https://eso-community.net/viewtopic.php?f=29&t=9169
    - https://aoe3homecity.com/en/strategies/decks
    - https://aoe3explorer.com/decks

---

#### Finding Homecity files

First navigate to: `<USER>\Savegame\`

> Note: Even though there is a `Homecities` folder, the game actually stores Home City data in the `Savegame` folder.

Find your file: `sp_<NAME_OF_YOUR_CITY>_homecity.xml`

This file contains various information, such as:

- Civilization
- Homecity (Difference to civilization will be explained later)
- Homecity name
- Hero name
- Level
- Skill points
- Decks and cards
- Cosmetics

---

#### Editing the File

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

After saving the file and launching the game:

- Your Home City will be level 131
- All cards will be unlockable (but not yet unlocked)

#### Understanding the file

I told you a couple of things that this file stores before, but let's locate them and understand them better.

```xml
<!-- These are regarding the Home City / Shipment mechanics -->
<defaultdirectoryid>0</defaultdirectoryid>              <!-- Where the game can find the file below 0 is root, 2 is campaigns. -->
<defaultfilename>homecityfrench.xml</defaultfilename>   <!-- Homecity to load (Controls shipments, decks, homecity cosmetics) -->

<!-- These are for in-game civilization -->
<civ>French</civ>
<!-- Changing this lets you mix civilizations and shipment sets (e.g., British civ with French shipments).
     This can cause missing or phantom cards, broken shipments (e.g., banks can't be built),
     and, in some cases, may crash the game. -->


<!-- Most of the following have no real importance to us -->
<hctype>HC</hctype>
<name>France</name> <!-- Name of the HC (What will be shown when selecting civilizations) -->
<heroname>Hero</heroname> <!-- You can change the Explorer name if you like -->
<herodogname></herodogname> <!-- Or give his card dog a name -->
<shipname></shipname>
<hcid></hcid>
<respec>1</respec>
<level>131</level>  <!-- Your level, usually lvl40 is minimum to unlock all good age up politicians -->
<xp>11533173</xp>
<skillpoints>131</skillpoints>  <!-- Available skill points (If you haven't yet unlocked anything, you will need around 130) -->
<xppercentage>2.190247</xppercentage>
<numpropunlocksearned>0</numpropunlocksearned>
```

> _Note: If you want to experiment with strong combinations, pairing the Spanish civ (faster shipments) with the German Home City (powerful shipments) is a particularly strong option._

> _Side note: Definitely expect other players to call you a hacker since you will have units not normally available to your civ._

### Unlocking Hidden Civilizations

Hopefully, you were able to complete the previous Project without issues. You can go back and retry, look for help in the [USER files troubleshooting](#user-files-troubleshooting) section, or get the files provided by this [guide](./Project1_Homecities/BaseGame/).
Now, let's move on and make a couple more bold changes for the second part of our first project.
Will use the same type of Homecity files that we just used in part 1 to unlock the campaign and hidden civilizations for single- and multiplayer games.

1. Create a new Homecity by simply copying a homecity file into the same folder and renaming it to `sp_Malta_homecity.xml`.
2. Open it up, and change the following fields:

```xml
<defaultdirectoryid>3</defaultdirectoryid>
<defaultfilename>blood ice steel\homecitySPCAct1.xml</defaultfilename>
<civ>SPCAct1</civ>
<name>Malta</name>
```

3. Start the game, unlock all new available cards, and create a new deck. (Don't use an existing one; it will leave you with invisible cards.)
4. Enjoy a game!

Now, where does this weird `homecitySPCAct1.xml` name come from? And why does it have this `blood ice steel\` prefix? And even weirder, for the first time, `defaultdirectoryid` is not 0, but 3? And how does this change our nation into the campaign Malta civilization?

All of those questions can be answered in detail with `Resource Manager` and going through the `SYSTEM\data\Data.bar` file, but for now, I'll only touch on this topic briefly. I'll later explain how and why this sort of black magic works, but until now, I'll just leave the solution.

```txt
# Vanilla
homecitygermans:Germans
homecitydutch:Dutch
homecitybritish:British
homecityspanish:Spanish
homecityottomans:Ottomans
homecityportuguese:Portuguese
homecityrussians:Russians
homecityfrench:French

# Vanilla Campaign Civs [defaultdirectoryid must be set to 3] (No starting crates and no explorer) (Malta, Mercs, USA)
blood ice steel\homecitySPCAct1:SPCAct1
blood ice steel\homecitySPCAct2:SPCAct2
blood ice steel\homecitySPCAct3:SPCAct3

# Vanilla Campaign Enemies (Normal British, but no starting crates)
homecitybritish:Pirate
homecitybritish:TheCircle
homecitybritish:NativeAmerican

# TWC Campaign Enemies
homecityXPSPC:XPSPC

# TAD Campaign Civs (No Hero, and different consulate allies/techs)
homecitySPC_CC:SPCChinese
homecitySPC_JC:SPCJapanese
homecitySPC_IC:SPCIndians

# TAD Campaign Enemies
homecitySPC_JC:SPCJapaneseEnemy
homecitybritish:SPCCompany

# Extra Note: You could mix civilizations with other home cities, for example, homecitygermans:Spanish, gives you a fast shipment nation, with a strong shipment homecity.
```

Or see it [here](/Age-of-Empires-3-Modding/Project1_Homecities/homecities_info.txt)

How to use this:

```xml
<defaultdirectoryid>0</defaultdirectoryid> <!-- 3 when marked as exception -->
<defaultfilename>FIRST_STRING.xml</defaultfilename>
<civ>SECOND_STRING</civ>
```

So, for the USA, we would have:

```xml
<defaultdirectoryid>3</defaultdirectoryid>
<defaultfilename>blood ice steel\homecitySPCAct3.xml</defaultfilename>
<civ>SPCAct3</civ>
```

While TheCircle would look something like this:

```xml
<defaultdirectoryid>0</defaultdirectoryid>
<defaultfilename>homecitybritish.xml</defaultfilename>
<civ>TheCircle</civ>
```

_Note that some `unique` civs use the homecitybritish; this causes the game to replace the civ value with British. You will have to manually change it back after each use_

---

Now for the good news and the bad news.

Good news: all required Home City files are already included with the game, so this setup generally works without crashes.

Bad news: other players may still see this as unintended or unfair and call it cheating.

If that happens, you can point out that this has been done before—for example, by pro player Aizamk on the now-defunct ESO servers: [Aizamk Makes America Great Again: USA Civ on TAD!?](https://www.youtube.com/watch?v=imr5uM83Rvs)

### USER Files Troubleshooting

#### Changes not appearing

- Reselect the home city
- Make sure file starts with `sp_` and ends with `.xml`
- Make sure you edited the correct file
- Verify the file is in the correct folder

#### Game resets civilization

- Some hidden civs are forced back to default
- Reapply changes after each match

#### Missing or broken cards

- Likely caused by a mismatched civ and Home City, delete the deck and create a new one

#### Game crashes on startup

- Is not related to our changes; the game simply ignores badly formed USER files. Make sure you haven't changed anything else, particularly that you aren't changing `SYSTEM` files.

#### Settings/Hotkeys gone

- Settings/Hotkeys do not transfer between Expansions. Make sure you're on the correct one.
- Your `USER\Users\NewProfile.xml` seems to have reset. It's recommended to always have a backup of this file, as setting up hotkeys is tedious.

### Last Remark

Before we move on to the next Project, if you are stuck with your homecities consider deleting the file. Deleting `USER` Files is safe, as in it won't destroy the game, but it will delete that piece of content/knowledge.

For example, if you delete your Profile and do not have a backup, you will also lose all your hotkeys.

## SYSTEM UI Files

Let's play a bit with the SYSTEM files now.

<span style="color:red">WARNING: Whenever you hear SYSTEM files, your mind should immediately jump to "BACKUP!". A single mistake could ruin your game. And you will do them.</span>

Now that I scared you a little bit, I can come clean and tell you that it's not always true, but please don't trust your gut.

Age of Empires 3 main files are in `.bar` files, like `SYSTEM\data\Data.bar`. These files can be opened with Resource Manager, alternatively with aoe3ed, but we will look further into that in the future. For now, I'll give you the relevant file.

The `SYSTEM` Files come in two big groups. `UI` files, and `Data` files. The boundary is not exactly clear, but a rule of thumb is that `UI` files are those that define visual things only, while `Data` ones can be mixed.

Now, why are we even differentiating between the two of them? Well, `Data` files contribute to the checksum at game start, while the `UI` ones don't. In practical terms, this means that if you change a `UI` file, you will still be able to play with other players without compatibility problems, but if you try to do the same with a `Data` file, it will fail (CRC error), as for all practical purposes, you are playing a different game version/mod.

Also, take into mind that while USER files get hotloaded, SYSTEM files are read once at game start. Any change to the files means the game needs to be restarted.

### Editing Player Colors

The `playercolors.xml` is, by default, read from the previously mentioned `.bar` file, but AoE3 allows you to replace these ones with a SYSTEM file mirroring the original one's location, which for our file is `SYSTEM\data\`.

_Side Task: If you wish to see the effect, you can try to create an empty `SYSTEM\data\playercolors.xml` file and boot up the game. You will see all colors defaulting to white._

```xml
<?xml version="1.0" encoding="utf-8"?>
<playercolors>

  <player num="0" color1="130 80 0" color2="140 90 10" color3="77 51 0" minimap="114 94 55">
  </player>

  <player num="1" color1="45 45 245" color2="55 55 255" color3="111 127 178" minimap="50 50 255">
  </player>

  <!-- Removed for clarity -->

  <friendorfoeself color1="75 75 230" color2="75 75 230" color3="75 75 230" minimap="0 0 255">
  </friendorfoeself>

  <friendorfoeally color1="215 215 30" color2="215 215 30" color3="215 215 30" minimap="255 255 0">
  </friendorfoeally>

  <friendorfoeenemy color1="230 40 40" color2="230 40 40" color3="230 40 40" minimap="255 0 0">
  </friendorfoeenemy>

</playercolors>
```

_See, and get, the full file here: [playercolors.xml](./Project2_PlayerColors/playercolors.xml)._

The file itself, like the homecities before, is written in `.xml`.

There are two main parts. PlayerX*color, and the \_friend or foe* colors. The first are `0: Mother Nature`, `1-8: Normal Players` and `9-12: Mostly for scenarios`. As for the _friend or foe_, they are the more commonly known team colors, usually blue, yellow, and red, for self, allies, and enemies, respectively.

> Side Note: If you intend to play multiplayer, having colors too different from the original can lead to confusing communication regarding colors.

### New Hotkeys

This Project will be rather small, as there aren't many interesting extra hotkey options, at least in the base game, which is the one we will be using here. However, there can be some specific ones, like loading a save game, a recorded game, or even a scenario.

Hotkeys are also a little bit special, as one can add them to both `USER` and `SYSTEM` files without any issues. Most often, when you write a file, it will replace the `SYSTEM` equivalent, but for configuration files, it's slightly different. Instead of overriding, they append.

I'm introducing this project at this point also because it will allow me to introduce you to one of the Age of Empires design features. In this game, everything is driven by commands sent to the engine. Essentially, every action the game takes, whether it’s moving a unit, updating the interface, or executing AI behavior, is triggered by a command. Most commands can be grouped, by their starting prefix, into the following categories:

- **XS** – Custom commands created for specific behaviors or modding purposes.
- **KB** – Knowledge-base related commands.
- **AI** – Commands that control the game’s AI.
- **RM** – Random Map related commands (Used to create the maps themselves).
- **TR** – Trigger commands, often used for events and scripted actions.
- **UI** – User interface commands that update menus, buttons, and displays.

But there are some other smaller categories, namely:

- camera
- toggle
- load/save
- gadget

A few even more obscure groups like `edit`, `move`, `render` and `toggle`, and obviously some extra miscellaneous, like `player`, `fog`, `blackmap`.

> We will look in depth into some of them in later projects. Meanwhile, if you just wish to see all commands, or explore them a bit, head on over to this [Language Server Protocol]() Project.

Back to the hotkeys, let's start analyzing the `SYSTEM\Startup\hotkeys.con` file.

> Note that although our work here will be rather small, there is quite a lot to grasp and learn. So don't feel overwhelmed.

Looking at the first group:

```c
map ("/", "game", "uiFindType(\"Hero\")")
map ("'", "game", "uiFindType(\"Ship\")")
map (".", "game", "uiFindIdleType(\"ValidIdleVillager\")")
map (",", "game", "uiFindIdleType(\"Military\")")
map (";", "game", "uiFindType(\"AbstractWagon\")")
map ("space", "game", "uiLookAtSelection")
map ("h", "game", "toggleHomeCityView")
map ("t", "game", "uiFindType(\"TownCenter\")")
```

We can immediately identify a pattern as follows:

```c
map (<key>, "game", <command>)
```

And we would be already mostly there. The only thing we could add is that "game" isn't just a constant, but it's actually the context.

Afaik, there are the following main contexts:

- root (Everywhere)
- game (Single- or Multi Player match)
- scenario (Scenario Editor)
- world (game + scenario)
- xxxAccel (simulates a mouse click on that button for that context)

and lots of other smaller niche ones: `cinematic`, `xsdebugger`, `tributedialog`, `playerComms`, `attackMove`, `flare`, `repair`, well, you can follow the file and see many others.

Regardless, a context is a state that controls stuff like allowed commands, ui, mouse pointer, and music. Everything in AoE3 is connected to a context.

It's also crucial to point out two other things. Strings need to be properly escaped , and you can chain commands.
Example of both on line 16:

```c
map ("control-b", "game", "uiFindType(\"Barracks\") uiFindType(\"Blockhouse\")")
```

Finally, we can start having some fun.
Let's start with two of the most commonly requested hotkeys: Building Rotator and Wall to Gate hotkey.

Building Rotator

```c
map ("shift-mousez", "building", "uiWheelRotatePlacedUnit")
```

and Wall to Gate hotkey.

```c
map ("g", "game", "uiTransformSelectedUnit(\"CWallGate\")")
```

Notice how in the first one, our context is not `game`, but `building`. So when we are "building" and then use "shift-mousez" (Mouse Wheel Rotation), it will call the `uiWheelRotatePlacedUnit` engine command, that will then rotate the building.

> When a command is a simple function, with no arguments, we can omit the ()

On the second hotkey, we are back to our "game" context, and in this case, we use a special command `uiTransformSelectedUnit`. Why do I say special? Because in this case, the game will try to apply this command to anything selected, but it will only work on Wall types, as they are the only ones with the ability to transform into games.

> I did say wall types, as the game allows you to convert any wall piece into a game, including connectors, and 1x2 pieces. Even more noteworthy is that the process is repeatable and reversible. All 4 types of walls can transform into all other four types of walls.
>
> > CWallGate, WallConnector, WallStraight5, WallStraight2
> > Unfortunately, this also means that you will keep spending money if you keep clicking the hotkey.

Another two, not so useful, but at the same time quite useful, are:

```c
map ("o", "game", "uiSetCameraStartLoc()")
map ("p", "game", "uiShowCameraStartLoc()")
```

This allows you to create and use a camera location. Akin to camera locations in `StarCrat2`, except that you can only have one.

You also have the possibility of changing how many units will be added to production.

```c
map ("shift-v", "TownCenterAccel", "tis(\"Settler\",2) tis(\"Coureur\",2)")
```

In this last example, we changed the town center's shift function from 5 to 2 villagers, although I can't imagine a practical use case for this.

Some hotkeys are quite useful at high-level gameplay.

```c
map ("shift-y", "game", "unitSetTactic(\"Melee\")") //Switch units to melee (A bit bugged on UI)
map ("shift-k", "game", "repairUnit(-1)") // Auto repair buildings
map ("shift-d", "game", "ransomExplorer") // Ransom the explorer back
```

Another higher-level hotkey is to select and delete the wall pillars to save the 5 wood.

```C
map ("u", "game", "uiFindIdleType(\"WallConnector\") uiDeleteAllSelectedUnits()")
```

> Note how we chain two commands. First, find WallConnector, and then delete what we have selected.
>
> > Attention: If you have no WallConnectors, and you happen to have other units selected, it will delete them. So be careful.

One last type of hotkeys that we will see will be ones that might be useful when dealing with Random Maps.

```c
map ("shift-e", "game", "blackmap") //Shows terrain
map ("shift-r", "game", "fog") //Shows units, including Gaia (so also animals, treasures, and native buildings)
```

### Alternative UIs

We won't go very far on this topic, but lots of interesting ones can be found online at [ESOC](https://eso-community.net/viewtopic.php?f=33&t=8594#:~:text=UI%20%3A,UI%0AQazitory%20UI).

We will only focus on one specific effect, transparency.

### SYSTEM UI Files Troubleshooting

## SYSTEM Data Files

### Editing Civilizations

### Editing Units (Intro)

This will be our last small tutorial project.
Until now, we have seen `USER` files that the game uses to bundle data and `SYSTEM` files used to control UI aspects. This time, we will look at small tweaks to some units.

## XS Scripting (Custom Maps)

We are slowly running out of small, useless changes that are simple to explain, and custom maps are one of the most requested and sought-after features of the game, and the community in general.
Have you ever sat down at the Map Editor and created your own perfect map only to realise you can’t play them with your friends? Is the AI broken and doesn't move?

Well, buckle up, because the project will be long, hard, and with a steep incline.

1. Go to `USER\RM` and create two files: `Tutorial.xs` and `Tutorial.xml`.

The `.xs` file is the one responsible for all the map generation, while the `.xml` is just a tiny file with some ui information. Let's start with the latter one.

```xml
<?xml version = "1.0" encoding = "UTF-8"?>
<mapinfo
    detailsText =  "XS Tutorial Custom Map\nDetails in Match Room."

    imagepath  = "ui\random_map\great_plains"
    displayName = "XS Tutorial Custom Map"
    cannotReplace = ""
    loadDetailsText = "XS Tutorial Custom Map.\nDetails while entering the match."

    loadBackground="ui\random_map\great_plains\great_plains_map">

    <loadss>ui\random_map\great_plains\great_plains_ss_03</loadss>
</mapinfo>
```

As of now, you can already go in-game, select Custom Maps, and select your map. Although it will just crash, as there is still nothing to load.
Right now, our issue is that the game doesn't know where to start creating our map. For this, we will need an entry point.

```c

int main(void) {

}

```

And that's it. Now we can launch our map for the first time.

> Side Note: You could make a file with a different function, `silver` instead of `main`, and the game would start to launch it, but it would be loading forever, as it can't resolve the entry point.

As you might have noticed, we ended up in a big black void, but don't worry, we haven't messed up (yet); we just haven't told the engine which floor we wish to generate.
At this point, we will have to once again talk about engine commands, in particular the ones from the `XS` group.

- A variety of commands can be found [here]()
- A more complete version [here]()
- An official (but for DE) [here]()

Right now, we are missing the ground. For that, we will have to tell the engine the map size and the ground type.

```c
rmSetMapSize(300,300);
rmTerrainInitialize("great_plains\ground5_gp",0.0);
```

And now we have a floor. But what good does a floor do if we do not have anything to place on it?

### Basics

Hopefully you know by now how to create a map, both `.xml` and `.xs` as well as the minimum required text to make it work. If you don't, just track back before continuing.

In this first mini project, we will flesh out our basic template a little.
The first step is finding ourselves a working base template. If you have the previous one, great! If not, you can find one [here](./Project7_CustomMaps/EmptyMap/): [EmptyMap.xml](./Project7_CustomMaps/EmptyMap/EmptyMap.xml) and [EmptyMap.xs](./Project7_CustomMaps/EmptyMap/EmptyMap.xs).

> Even though the `.xml` and `.xs` files are named EmptyMap, the ingame name is still the same as in the previous tutorial: `XS Tutorial Custom Map`.

Now, what exactly makes Age of Empires 3, Age of Empires 3? Well, it's all the animals, trees, mines, natives, trade routes, and of course, the players.

So let's start with the players.

For this, we have a very simple function `rmPlacePlayer`, which takes a played_id and an x and z coordinate pair.

```c
// Just some x and z coordinates to place our players
float xAxis = 0.5;
float zAxis1 = 0.25;
float zAxis2 = (1.0 - zAxis1);

// Setting up the TC (TC at start is responsible for spawning the villagers and crates, so we don't need to worry about that)
int TCID = rmCreateObjectDef("player TC"); // Creating the TC id
rmAddObjectDefItem(TCID, "townCenter", 1, 0); // TC id, receives 1 unit of type TownCenter, perfectly at location
rmPlaceObjectDefAtLoc(TCID, 1, xAxis, zAxis1); // Now place that defined object for player 1
rmPlaceObjectDefAtLoc(TCID, 2, xAxis, zAxis2); // And for player 2

// And here we add our explorer (+dog for Spain)
int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
rmPlaceObjectDefAtLoc(startingUnits, 1, xAxis+0.05, zAxis1+0.05);
rmPlaceObjectDefAtLoc(startingUnits, 2, xAxis+0.05, zAxis2+0.05);
```

> Don't forget that Player 0 is Gaia.

Now we have players, but the map is still empty and bland. Let's add some trees.

```c
int i = 0;
for (i=0; <100)
{
    // Creating the treeID
    int treeID = rmCreateObjectDef("tree"+i);

    // Creating an object with that id, in this case a group of 2 to 3 "TreeGreatPlains", with a clustering distance of 4
    rmAddObjectDefItem(treeID, "TreeGreatPlains", rmRandInt(2,3), 4.0);

    // Finally, we place the object on the map (at random for now)
    rmPlaceObjectDefAtLoc(treeID, 0, rmRandFloat(0.0, 1.0), rmRandFloat(0.0, 1.0));
}
```

and mines!

```c
for (i=0; <10)
{
    int mineID = rmCreateObjectDef("mine"+i);
    rmAddObjectDefItem(mineID, "mine", rmRandInt(2,3), 4.0);
    rmPlaceObjectDefAtLoc(mineID, 0, rmRandFloat(0.0, 1.0), rmRandFloat(0.0, 1.0));
}
```

Very well, now we have both trees and mines. It's time for us to give our map some animals.

```c
for (i=0; <10)
{
    int bisonID = rmCreateObjectDef("bison"+i);
    rmAddObjectDefItem(bisonID, "bison", rmRandInt(5, 10), 5.0);
    rmSetObjectDefCreateHerd(bisonID, true);
    rmPlaceObjectDefAtLoc(bisonID, 0, rmRandFloat(0.0, 1.0), rmRandFloat(0.0, 1.0));
}
```

We did it once again, mostly the same. The only difference now is that we added a new `rmSetObjectDefCreateHerd` definition to our bison object, which will treat all the animals in that group as a herd.

However, as you might have noticed already, we aren't always getting the numbers that we wish.

In fact, we can see this very easily if we modify our file to:

```c
void main(void)
{
    rmSetMapSize(200,200);
    rmTerrainInitialize("great_plains\ground5_gp",0.0);

    int mineID = rmCreateObjectDef("mine");
    rmAddObjectDefItem(mineID, "mine", 1, 0.0);
    rmPlaceObjectDefAtLoc(mineID, 0, .5, .5);

    int treeID = rmCreateObjectDef("tree");
    rmAddObjectDefItem(treeID, "TreeGreatPlains", 1, 0.0);
    rmPlaceObjectDefAtLoc(treeID, 0, .5, .5);
}
```

In this version, we are creating a single mine, followed by a single tree, in the exact same place. If you try it out, you will realise that the mine always blocks the tree from spawning. And if you invert the order, the tree will always block the mine from spawning.

This is a huge hassle. Imagine you load into a game and your Town Center isn't there?
For this reason, most maps follow a specific order for placement, usually a mix of size and importance.

1. Ground, Cliffs, and Water Bodies
2. Player Areas
3. Trade Routes and Natives
4. Player Starting Resources
5. Common Resources (Mines, Trees, Hunts, Treasures, Herdables)
6. Embellishments

We will explore this order a bit more in the next subchapter, but for now, I'd recommend trying to create one map of your own with the same concept that we used. Particularly, try to find out what happens when you place 4 players in a 2-player map, or if you make the map too big, or too small. What happens if you just keep placing stuff at random? Do they have spacing? Clustering? Balance?

If you do feel ready with both C and basic XS, then feel free to move to the next subchapter.

### Changing Existing Maps

This chapter will be relatively big. There will be lots of smaller concepts and functions.

If you wish to start with a more general look, feel free to start with [M0nTy_PyTh0n's Guide](https://web.archive.org/web/20100421112530/http://hyenastudios.mugamo.com/aoe3rmstutorial.htm#I).

### Creating a Custom Map

### Tips and Tricks

### Advanced Guide

### XS-Injections
