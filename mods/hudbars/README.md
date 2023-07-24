# minetest HUD bars

HUD mod to display as bars and API for healt, armor, breath, hunger

## Information
--------------

This mod changes the HUD of Minetest. It replaces the default health and breath
symbols by horizontal colored bars with text showing the number (or more configured one).

Furthermore, it enables other mods to add their own custom bars to the HUD,
this mod will place them accordingly.

![](screenshot.png)

### Features

* This mod adds a mechanic for hunger, using "satiation" concept
* This mod adds information bar for armor status
* Eating an apple (from Minetest Game) increases your satiation by 2

> Warning: Eating food will not directly increase your health anymore, as long as the food
item is supported by this mod (see below).

> Warning: ! Some foods may be poisoned. If you eat a poisoned item, you may still get a satiation
boost, but for a brief period you lose health points because of food poisoning. However,
food poisoning can never kill you.

## Technical info
-----------------

This mod its a simplification of hudbars+hbarmor+hbhunger for performance 
it provides extra checks for security an backguard compatibility 
on all minetest engines. TExture media was optimized for low end devices.

This fusioned hudbars 2.3.4.0 and hbarmor 1.0.1 with hbhunger 1.1.2 
with aditional patches rejected by upstream that improves performance.

#### About armor support

This mod adds a simple HUD bar which displays the current damage
of the player's armor (from the 3D Armor [`3d_armor`] mod) as a percentage (rounded).

100% armor means the armor is in perfect shape. 0% means the armor is almost destroyed
or non-existant. Note that to reach 100%, the player must wear at least 4 or 6 different
pieces of armor in perfect shape.

#### About hunger supoort

This mod adds a hunger buildin mechanic to the game. Players get a new attribute called “satiation”:

* A new player starts with 20 satiation points out of 30
* Actions like digging, placing and walking cause exhaustion, which lower the satiation
* Every 800 seconds you lose 1 satiation point without doing anything
* At 1 or 0 satiation you will suffer damage and die in case you don't eat something
* If your satiation is 16 or higher, you will slowly regenerate health points
* Eating food will increase your satiation (Duh!)

All mods which add food through standard measures (`minetest.item_eat`) are already
supported automatically. Poisoned food needs special support.

#### Dependencies

* default
* 3d_armor
* farming

More mod are optionally supported depending of availability

#### Known supported food mods

* Apple and Blueberries from Minetest Game [`default`]
* Red and brown mushroom from Minetest Game [`flowers`]
* Bread from Minetest Game [`farming`]
* [`animalmaterials`] (Mob Framework (`mobf` modpack))
* Bushes [`bushes`]
* [`bushes_classic`]
* Creatures [`creatures`]
* [`dwarves`] (beer and such)
* Docfarming [`docfarming`]
* Ethereal / Ethereal NG [`ethereal`]
* Farming Redo [`farming`] by TenPlus1
* Farming plus [`farming_plus`]
* Ferns [`ferns`]
* Fishing [`fishing`]
* [`fruit`]
* Glooptest [`glooptest`]
* JKMod ([`jkanimals`], [`jkfarming`], [`jkwine`])
* [`kpgmobs`]
* [`mobfcooking`]
* [`mooretrees`]
* [`mtfoods`]
* [`mushroom`]
* [`mush45`]
* Seaplants [`sea`]
* Simple mobs [`mobs`]
* Pizza [`pizza`]
* Not So Simple Mobs [`nssm`]

#### Statbar mode

If you use the statbar mode of the HUD Bars mod, these things are important to know:
As with all mods using HUD Bars, the bread statbar symbols represent the rough percentage
out of 30 satiation points, in steps of 5%, so the symbols give you an estimate of your
satiation. This is different from the hunger mod by BlockMen.

> **Warning** Keep in mind if running a server with this mod, 
that the custom position should be displayed correctly on every screen size.

#### Current version

The current version is 2.3.5 its a plus fork from original cos current 
minetest most close mods developers are not so open to support already working servers.

It works for Minetest 0.4.16+/5.X+ or later.

#### Configurations

This mod can be configured quite a bit. You can change HUD bar appearance, offsets, ordering, and more.
Use the advanced settings menu in Minetest for detailed configuration.

| configuration name           | Description                           | type | values, default/min/max  |
| ---------------------------- | ------------------------------------- | ---- | ------------------------ |
| hudbars_hp_player_maximun    | set the maximun hp of the player healt | int | 10 20 60 |
| hudbars_br_player_maximun    | set the maximun player breath value   | int | 10 10 30 |
| hbarmor_autohide             | Automatically hide armor HUD bar      | bool | false |
| hbhunger_satiation_tick      | Time in seconds which 1 saturation point is taken    | float | 800 |
| hbhunger_satiation_sprint_dig   | exhaustion increased this value after digged node | float | 3 |
| hbhunger_satiation_sprint_place | exhaustion increased this value after placed      | float | 1 |
| hbhunger_satiation_sprint_move  | exhaustion increased this value if player moves   | float | 0.2 |
| hbhunger_satiation_sprint_lvl   | at what exhaustion player satiation gets lowerd   | float | 160 |
| hudbars_bar_type             | HUD bars style                        | enum | progress_bar (progress_bar,statbar_classic,statbar_modern) |
| hudbars_autohide_breath      | Automatically hide breath indicators  | bool | true |
| hudbars_alignment_pattern    | HUD bars alignment pattern            | enum | zigzag (zigzag,stack_up,stack_down) |
| hudbars_sorting              | HUD bars order                        | string | breath=1, health=0 |
| hudbars_pos_left_x           | Left HUD bar screen x position        | float | 0.5 0.0 1.0 |
| hudbars_pos_left_y           | Left HUD bar screen y position        | float | 1.0 0.0 1.0 |
| hudbars_pos_right_x          | Right HUD bar screen x position       | float | 0.5 0.0 1.0 |
| hudbars_pos_right_y          | Right HUD bar screen y position       | float | 1.0 0.0 1.0 |
| hudbars_start_offset_left_x  | Left HUD bar x offset                 | int | -175 |
| hudbars_start_offset_left_y  | Left HUD bar y offset                 | int | -86 |
| hudbars_start_offset_right_x | Right HUD bar x offset                | int | 15 |
| hudbars_start_offset_right_y | Right HUD bar y offset                | int | -86 |
| hudbars_start_statbar_offset_left_x  | Left HUD statbar x offset     | int | -265 |
| hudbars_start_statbar_offset_left_y  | Left HUD statbar y offset     | int | -90 |
| hudbars_start_statbar_offset_right_x | Right HUD statbar x offset    | int | 25 |
| hudbars_start_statbar_offset_right_y | Right HUD statbar y offset    | int | -90 |
| hudbars_vmargin              | Vertical distance between HUD bars    | int | 24 0 |
| hudbars_tick                 | Default HUD bars update interval      | float | 0.2 0.0 4.0 |

#### API

The API is used to add your own custom HUD bars.
Documentation for the API of this mod can be found in [`API.md`.](API.md)

## Legal

#### License of source code

Authors:

* Wuzzy (2015)
* PICCORO Lenz McKAY (2023)

This mod was forked from the “Better HUD”  (and hunger) [hud] mod by BlockMen.

Translations:

* German: Wuzzy
* Portuguese: BrunoMine
* Turkish: admicos
* Dutch: kingoscargames
* Italian: Hamlet
* Malay: muhdnurhidayat
* Russian: Imk
* Spanish: wuniversales

This program is free software. It comes without any warranty, to
the extent permitted by applicable law. You can redistribute it
and/or modify it under the terms of the MIT License.

#### Licenses of textures

* `hudbars_icon_health.png`—celeron55 (CC BY-SA 3.0), modified by BlockMen
* `hudbars_icon_breath.png`—kaeza (MIT License), modified by BlockMen, modified again by Wuzzy
* `hudbars_bar_health.png`—Wuzzy (MIT License)
* `hudbars_bar_breath.png`—Wuzzy (MIT License)
* `hudbars_bar_background.png`—Wuzzy (MIT License)
* `hbarmor_icon.png`—Stu ([CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)), modified by BlockMen
* `hbarmor_bar.png`—Wuzzy (MIT License)
* `hbhunger_icon.png`—PilzAdam ([MIT License](https://opensource.org/licenses/MIT)), modified by BlockMen
* `hbhunger_bar.png`—Wuzzy (MIT License)
* `hbhunger_icon_health_poison.png`—celeron55 ([CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)), modified by BlockMen, modified again by Wuzzy

#### License references

* [CC-BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)
* [MIT License](https://opensource.org/licenses/MIT)

