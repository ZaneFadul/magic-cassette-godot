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
```
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

The configuration file reads a track as follows:
```
track_name = [bpm, total_beats, <audio_file_path>]

#Note: audio_file_path is optional, but the default path is "res://audio/[track_name].mp3".
#Should you want to change the default audio path, you can change it in the _create_track_obj() method in audio_manager_config.gd
```
For our fantasy town, we want an overworld theme, an item shop theme, and a castle theme. As such, we will add the following tracks to `audio.cfg`
```terraform
[Tracks]
overworld=[100, 120, "res://audio/bgm/overworld.mp3"]
item_shop=[80, 32, "res://audio/bgm/buildings/item_shop.ogg"]
castle=[120, 64] #will default path to "res://audio/castle.mp3"
```

## `Actions`

## `State Variables`

## `Trees`

### Methods

### Conclusion

































