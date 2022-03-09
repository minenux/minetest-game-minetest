Default mods
------------

For information check [../README.md](../README.md)

## Content

| mod name           | origin or work                                      | version | info |
| ------------------ | --------------------------------------------------- | -------- | --- |
| api                | https://codeberg.org/minenux/minetest-game-minetest | https://codeberg.org/minenux/minetest-game-minetest/commit/c7cb79422ba19c696966472942db6177c934838d | [api](../game_api.md) |
| beds               | https://codeberg.org/minenux/minetest-mod-beds      | https://codeberg.org/minenux/minetest-mod-beds/commit/7b6fae96d5e273dad9a373e63eb958145c9bfbef | [beds/README.md](beds/README.md) |
| boats              | https://codeberg.org/minenux/minetest-mod-boats     | https://codeberg.org/minenux/minetest-mod-boats/commit/3832de08f705d5d2e7b5a971760e5fad1653305f | [boats/README.md](boats/README.md) |
| bucket             | https://codeberg.org/minenux/minetest-mod-bucket.git | https://codeberg.org/minenux/minetest-mod-bucket/commit/1d9f32295aba3ef2a86be302050f34c1766e93d5 | [bucket/README.md](bucket/README.md) |
| bones              | https://codeberg.org/minenux/minetest-game-minetest | https://codeberg.org/minenux/minetest-game-minetest/commit/c7cb79422ba19c696966472942db6177c934838d | |
| carts              | https://codeberg.org/minenux/minetest-mod-carts     | https://codeberg.org/minenux/minetest-mod-carts/commit/dcbca916cffdcec281f0129ef350db2686bda933 | [carts/README.md](carts/README.md) |
| creative           | https://codeberg.org/minenux/minetest-mod-creative  | https://codeberg.org/minenux/minetest-mod-creative/commit/ca09e773701f834fec7de18bf13598b3323778db | [creative/README.md](creative/README.md) |
| default            | https://codeberg.org/minenux/minetest-game-minetest | https://codeberg.org/minenux/minetest-game-minetest/commit/c7cb79422ba19c696966472942db6177c934838d | |
| doors              | https://codeberg.org/minenux/minetest-mod-doors     | https://codeberg.org/minenux/minetest-mod-doors/commit/a89ab0454deb4933b6e4971c57055c40b7938e5b | [doors/README.md](doors/README.md) |
| dye                | https://codeberg.org/minenux/minetest-game-minetest | https://codeberg.org/minenux/minetest-game-minetest/commit/c7cb79422ba19c696966472942db6177c934838d | |
| farming            | https://codeberg.org/minenux/minetest-mod-farming   | https://codeberg.org/minenux/minetest-mod-farming/commit/00e4b3cb89d3c1b1d66b6af4821191c1d667e1bc | [farming/README.md](farming/README.md) |
| fire               | https://codeberg.org/minenux/minetest-mod-fire      | https://codeberg.org/minenux/minetest-mod-fire/commit/4e5f7ad55314bd9b126fb133cfc5a32fa58b20d2 | [fire/README.md](fire/README.md) |
| flowers            | https://codeberg.org/minenux/minetest-game-minetest | https://codeberg.org/minenux/minetest-game-minetest/commit/c7cb79422ba19c696966472942db6177c934838d | |
| give_initial_stuff | https://codeberg.org/minenux/minetest-game-minetest | https://codeberg.org/minenux/minetest-game-minetest/commit/c7cb79422ba19c696966472942db6177c934838d | |
| killme             | https://codeberg.org/minenux/minetest-game-minetest | https://codeberg.org/minenux/minetest-game-minetest/commit/c7cb79422ba19c696966472942db6177c934838d | |
| sfinv              | https://codeberg.org/minenux/minetest-game-minetest | https://codeberg.org/minenux/minetest-game-minetest/commit/c7cb79422ba19c696966472942db6177c934838d | |
| stairs             | https://codeberg.org/minenux/minetest-mod-stairs    | https://codeberg.org/minenux/minetest-mod-stairs/commit/c3a5af6c452daca599d226df694df1b75f15c110 | [stairs/README.md](stairs/README.md) |
| screwdriver        | https://codeberg.org/minenux/minetest-game-minetest | https://codeberg.org/minenux/minetest-game-minetest/commit/c7cb79422ba19c696966472942db6177c934838d | |
| tnt                | https://codeberg.org/minenux/minetest-mod-tnt       | https://codeberg.org/minenux/minetest-mod-tnt/commit/8195861f905a90b53cd52348deb34df41a053027 | [tnt/README.md](tnt/README.md) |
| vessels            | https://codeberg.org/minenux/minetest-game-minetest | https://codeberg.org/minenux/minetest-game-minetest/commit/c7cb79422ba19c696966472942db6177c934838d | |
| walls              | https://codeberg.org/minenux/minetest-game-minetest | https://codeberg.org/minenux/minetest-game-minetest/commit/c7cb79422ba19c696966472942db6177c934838d | |
| wool               | https://codeberg.org/minenux/minetest-mod-wool      | https://codeberg.org/minenux/minetest-mod-wool/commit/de642a08e80bfd7a4a1e5629e50458a609dbda3a | [wool/README.md](wool/README.md) |
| xpanes             | https://codeberg.org/minenux/minetest-game-minetest | https://codeberg.org/minenux/minetest-game-minetest/commit/c7cb79422ba19c696966472942db6177c934838d | |

The default mod provides sethome and player_api call ones, binoculars from v5 are 
just separate privilegies for zoom, butterflies and fireflies from v5 can be set 
by dmobs or mobs_doomed mod, the spawn mod is just minimal spawn management 
pooly provided and better managed by mods like rspawn and spawnrandom.

## Compatibility

This source code and files are only compatible with matched minetest4 engine
from https://codeberg.org/minenux/minetest-engine/src/branch/stable-4.0 
Additionally, when the Minetest4 engine is tagged to be a certain version (e.g.
4.0.17), Minetest Game is tagged with the version 4.0.17 too.

## Licensing

See `LICENSE.txt`
