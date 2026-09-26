# Serious Chicken Game

A scrolling platformer where you play a chicken crossing a rainbow bridge. You dodge whatever is flying at you and collect eggs along the way.

- Play: [itch.io](https://unitedfailures.itch.io/serious-chicken-game)
- Made: October to December 2024. It started as a Gumbo x GameMaker Game Jam entry.
- Team: [@mfclinton](https://github.com/mfclinton) (programming), [CelestialJoy](https://celestialjoy.itch.io) (art), [@MrAozora](https://github.com/MrAozora) (art and music)
- Engine: GameMaker, GML, Python

This is an export of a private repo with only the code we wrote. The art, audio, rooms, and GameMaker project files aren't included. The history is squashed into one commit.

## What I built

- The world scrolls past a camera that never moves. Everything shares one world speed that gets added to its movement, so standing still drifts you backward and getting pushed off screen kills you. The background, clouds, and rainbow bridge each scroll at their own rate off that speed, and enemies stay frozen until they come into view.
- Levels never end. I stitch premade rooms together as you play, spawning the next one as soon as the last piece of the current one scrolls in, and every so often it switches between the sky and space zones with a background crossfade.
- I wrote Python tools for building those rooms. They export the rooms to the JSON the game loads, pick the right cloud and log tiles based on the blocks around them, and write the fixed rooms back.
- The chicken, enemies, and pickups all share the same movement and collision code. Pacing enemies turn around at ledges, and the chicken has buffered jumps, double jumps, coyote time, and a glide you can toggle. Pausing just sets a timescale that every object follows.
- The menus run on a small UI framework I built. Every element shares one base object and works with keyboard or mouse, and data bound elements like the score count up to their new values on their own. I also wrote the shaders for the slider fill and the scrolling background.
