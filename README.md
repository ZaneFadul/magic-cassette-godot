# Magic Cassette (for Godot)
## *a lightweight solution for audio management*
## Intro
Well, the file names definitely don't correlate with the title *or* this repository, but that will change as I flesh this project out. For now, I'll help you guys understand a little bit how this audio manager works!

**Magic Cassette** is a lightweight audio manager that persists over a project, and will automatically change sound simply given a set amount of parameters. This solution was designed to make audio management more flexible and centralized, so that you don't have to worry about fixing the logical errors of why that town music keeps overlapping itself!. Using a tree-like data structure, when Magic Cassette's internal state is changed *(due to changes somewhere else in the game's variables)*, the manager will traverse the tree to return an Audio Action. This Action determines what is played and how it is played.

The motivation for this project is actually based on a Unity animation solution called [Reanimator](https://github.com/aarthificial/reanimation) by [@aarthificial](https://github.com/aarthificial). His work is so impressive; seriously, go check him out!

## Installation
I *did* say this was lightweight. All you have to do is copy the `AudioManager` folder into your own  project! The path will change dynamically, so you don't have to worry about nested directories breaking anything. The folder structure for this example project is as follows:
```
res://
└────audio
|       [audio files, mp3s...]
└────scenes
    |
    └────audio
    |   |
    |   └──── AudioManager
    |       |
    |       └──> audio.cfg [aka the only file you'll need to edit]
    |
    └───levels
    |
   ...
```

## Set Up
Once you have the `AudioManager` folder in your project, you now need to fill in `audio.cfg`, which can be found in the `AudioManager` folder. The configuration file should look like this:
```js
[Tracks]

[Actions]

[State Variables]

[Trees] 

```

For our example how to fill this configuration file, we're going to set up our manager for ***playing music in a fantasy town.***

## `Tracks`
**Tracks** are objects that store:
- an **alias**
- an audio file path
- the BPM (Beats Per Minute)
- the Total Beats (in the song)

A good rule of thumb is to give your audio track names consistent. "*untitled(3).mp3*" isn't the best name for your dungeon music.

The configuration file reads a **Track** as follows:
```js
track_name = [bpm, total_beats, <audio_file_path>]

#Note: audio_file_path is optional, but the default path is "res://audio/[track_name].mp3".
#Should you want to change the default audio path, you can change it in the _create_track_obj() method in audio_manager_config.gd
```
For our fantasy town, we want an overworld theme, an item shop theme, and a castle theme. As such, we will add the following tracks to `audio.cfg`
```js
[Tracks]
overworld = [100, 120, "res://audio/bgm/overworld.mp3"]
item_shop = [80, 32, "res://audio/bgm/buildings/item_shop.ogg"]
castle = [120, 64] #defaults path to "res://audio/castle.mp3"
```
**Note: Make sure you're using *"double quotes"* instead of *'single quotes'*, otherwise the configuration will fail.**

BPM and Total Beats are used for making sure the audio loops *seamlessly*, and for allowing users to emit signals on certain beats if they want to sync the game's atmosphere with their music.

## `Actions`
**Actions** are objects that store:
- an **alias**
- an **audio control method**
- a reference to a **Track** alias
- extra parameters for said **Track**

This is probably a lot to take in, I know, but once you see the syntax for inputting **Actions**, you'll realize it's actually pretty easy! It's just a dictionary abstraction that reads like a sentence.

The configuration file reads an **Action** as follows:
```js
action_name = {"audio_control_method" : {"track_name" : {[extra parameters for the track]} } }

#Note: Extra parameters can simply be left as an empty dictionary: {}, this defaults the audio to loop.
```
Now, I need to create **Actions** for all of the **Tracks** I want to play.
```js
[Actions]
play_overworld = {"play" : {"overworld" : {} } }
play_item_shop = {"play" : {"item_shop" : {} } }
play_castle = {"play" : {"castle : {} } }
```
Again, ***think of the syntax as an abstract sentence, with each word being contained within its own dictionary.***

Oh wait. I forgot... my castle theme has an intro that shouldn't be kept in the loop! There are two ways to fix this. Let's say I want to separate my castle theme into two files: `castle_intro` and `castle_loop`. Let me show how this fix would look in `audio.cfg`.

#### Method 1:
```js
[Tracks]
castle_intro = [120, 4]
castle_loop = [120, 28]

[Actions]
play_castle = {"play" : {"castle_intro" : {"on_end" : "next", "next_song" : "castle_loop"}
```
#### Method 2:
```js
[Tracks]
castle = [120, 32]

[Actions]
play_castle = {"play" : {"castle_intro" : {"on_end" : {"loop_at" : {"beat" : 5 } } } }
```

**Note: Method 2 doesn't actually work...*yet.* It'll be awesome when it does though!**
## `State Variables`
**State Variables** are objects that store:
- **aliases** that correspond to tree roots
- a path to a scene node
- the name of a function in said scene node that returns the variable

## `Trees`

### Methods

### Conclusion

































