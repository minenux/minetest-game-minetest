Minetest mod tnt
================

Add tnt tool to make explotions

Information
-----------

This mod is named `tnt`, it adds TNT to Minetest. TNT is a tool to 
help the player in mining or cause mayor damage in area. thiis mod 
featured the `tnt_stick` tool

![screenshot.png](screenshot.png)

Technical information
---------------------

This mod improves more realistic usage of tnt, by the tnt sticks, 
for both older and newers engines.

Craft gunpowder by placing coal and gravel in the crafting area.
The gunpowder can be used to craft TNT sticks or as a fuse trail for TNT.

The sticks now is the usage for craft TNT's.

| name      | node          | craft              | usage |
|--- ------ | ------------- | ------------------ | ------ |
| TNT Stick | tnt:tnt_stick | round a paper with 6 tnt sticks | craft tnt |
| TNT       | tnt:tnt       | using 9 tnt sticks | destruction ratio |
| Gunpowder | tnt:gunpowder | coal and gravel    | powder to ignite tnt |

**NOTE**: The sticks are not usable as an explosive.

To craft 2 TNT sticks:
```
G_G
GPG
G_G
```
* G = gunpowder
* P = paper

Craft TNT from 9 TNT sticks.

There are different ways to ignite TNT:
  1. Hit it with a torch.
  2. Hit a gunpowder fuse trail that leads to TNT with a torch or flint-and-steel.
  3. Activate it with mesecons (fastest way).

* For 1 TNT: Node destruction radius is 3 nodes by default, configurable.
* Player and object damage radius is 6 nodes.

License
-------

See [license.txt](license.txt) for license information.

**Authors of source code**

PilzAdam (MIT)
ShadowNinja (MIT)
sofar (sofar@foo-projects.org) (MIT)
Various Minetest developers and contributors (MIT)

**Authors of media**

BlockMen (CC BY-SA 3.0):
All textures not mentioned below.

ShadowNinja (CC BY-SA 3.0):
tnt_smoke.png

Wuzzy (CC BY-SA 3.0):
All gunpowder textures except tnt_gunpowder_inventory.png.

sofar (sofar@foo-projects.org) (CC BY-SA 3.0):
tnt_blast.png

paramat (CC BY-SA 3.0)
tnt_tnt_stick.png - Derived from a texture by benrob0329.

TumeniNodes (CC0 1.0)
tnt_explode.ogg
renamed, edited, and converted to .ogg from Explosion2.wav
by steveygos93 (CC0 1.0)
<https://freesound.org/s/80401/>

tnt_ignite.ogg
renamed, edited, and converted to .ogg from sparkler_fuse_nm.wav
by theneedle.tv (CC0 1.0)
<https://freesound.org/s/316682/>

tnt_gunpowder_burning.ogg
renamed, edited, and converted to .ogg from road flare ignite burns.wav
by frankelmedico (CC0 1.0)
<https://freesound.org/s/348767/>


