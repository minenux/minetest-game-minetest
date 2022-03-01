Minetest4 Game
==============

The default game for the Minetest4 engine.  

This is a fork from minetest default game, this 
are made from minenux project https://codeberg.org/minenux
for minetest v5 and minetest v4 or 0.4.

Introduction
------------

This is the branch `stable-4.1` of minetest game for minetest4 a version 
that is focused in v4 of minetest but mainly in 0.4.18/4.0.18 release. There's 
also a minetest4 game version too in `stable-4.0` branch.

This are focused to provide minimal default game featured for minetest4 
to be playable, with an [api](game_api.md) for more aditions (in the form of mods)

For further information, check the [Minetest Wiki](https://wiki.minetest.net/Subgames/Minetest_Game) 

## Download

Can be obtained from https://codeberg.org/minenux/minetest-game-minetest/tags 
those like 4.0.X by example https://codeberg.org/minenux/minetest-game-minetest/releases/tag/4.0.18

It will download a tar.gz file, uncompress the content and a directory will be created, 
the name of the directory does not matter, the contents will be used later to install.

When stable releases are made, Minetest Game and the Minetest engine is packaged 
and made available at https://codeberg.org/minenux/minetest-engine/archive/stable-4.0.tar.gz 
or generally at https://codeberg.org/minenux/minetest-engine/releases/tag/4.0.18 by example.

## Installation

This game can be used in any version from 0.4.18 to 4.0.18 and 5.2, it does nto work with 5.3 or up

After download, rename the directory decompressed to `minetest_game` and put to the "games" directory:

- GNU/Linux: If you use a system-wide installation place
    it in ~/.minetest4/games/.
- Others:  `minetest/games/` or `games` directory from the path were the binary are.

For further information or help, see: https://wiki.minetest.net/Installing_Mods

## Content

* api
* beds
* bucket
* bones
* boats
* butterflies
* creative
* default
* doors
* farming
* fire
* fireflies
* give_initial_stuff
* stairs
* carts
* dye
* flowers
* screwdriver
* tnt
* xpanes
* sfinv
* vessels
* walls
* wool

The default mod provides sethome and player_api call ones, binoculars from v5 are 
just separate privilegies for zoom, the spawn mod is just minimal spawn management 
pooly provided and better managed by mods like rspawn and spawnrandom.

## Compatibility

This source code and files are only compatible with matched minetest4 engine
from https://codeberg.org/minenux/minetest-engine/src/branch/stable-4.1 
Additionally, when the Minetest4 engine is tagged to be a certain version (e.g.
4.0.18), Minetest Game is tagged with the version 4.0.18 too.

## Licensing

See `LICENSE.txt`
