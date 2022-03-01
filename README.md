Minetest5 Game
==============

The default game for the Minetest5 engine.  

This is a fork from minetest default game, this 
are made from minenux project https://codeberg.org/minenux
for minetest v5 and minetest v4 or 0.4.

Introduction
------------

This is the branch `stable-5.2` of minetest game for minetest5 a version 
that is focused in v5 of minetest but mainly in 5.2 release. There's 
also a minetest4 game version too in `stable-4.0` branch.

This are focused to provide minimal default game featured for minetest5 
to be playable, with an [api](game_api.md) for more aditions (in the form of mods)

For further information, check the [Minetest Wiki](https://wiki.minetest.net/Subgames/Minetest_Game) 

## Download

Can be obtained from https://codeberg.org/minenux/minetest-game-minetest/tags 
those like 5.2.X by example https://codeberg.org/minenux/minetest-game-minetest/releases/tag/5.2.1

It will download a tar.gz file, uncompress the content and a directory will be created, 
the name of the directory does not matter, the contents will be used later to install.

When stable releases are made, Minetest Game and the Minetest engine is packaged 
and made available at https://codeberg.org/minenux/minetest-engine/archive/stable-5.2.tar.gz 
or generally at https://codeberg.org/minenux/minetest-engine/releases/tag/5.2.1 by example.

## Installation

This game can be used in any version from 5.0 to 5.2, it may work with 5.3 but not with 5.5

After download, rename the directory decompressed to `minetest_game` and put to the "games" directory:

- GNU/Linux: If you use a system-wide installation place
    it in ~/.minetest5/games/.
- Others:  `minetest/games/` or `games` directory from the path were the binary are.

For further information or help, see: https://wiki.minetest.net/Installing_Mods

## Content

* api
* beds
* butterflies
* default
* doors
* dungeon_loot
* farming
* fire
* give_initial_stuff
* bucket
* map
* bones
* fireflies
* player_api
* stairs
* wool
* binoculars
* carts
* dye
* flowers
* screwdriver
* tnt
* xpanes
* boats
* creative
* env_sounds
* game_commands
* sethome
* sfinv
* spawn
* weather
* vessels
* walls

## Compatibility

This source code and files are only compatible with matched minetest5 engine
from https://codeberg.org/minenux/minetest-engine/src/branch/stable-5.2 
Additionally, when the Minetest5 engine is tagged to be a certain version (e.g.
5.2.1), Minetest Game is tagged with the version 5.2.1 too.

## Licensing

See `LICENSE.txt`
