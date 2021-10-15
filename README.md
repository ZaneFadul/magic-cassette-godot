# Magic Cassette (for Godot)
## *a lightweight solution for audio management*
### Intro
Well, the file names definitely don't correlate with the title *or* this repository, but that will change as I flesh this project out. For now, I'll help you guys understand a little bit how this audio manager works!

**Magic Cassette** is a lightweight audio manager that persists over a project, and will automatically change sound simply given a set amount of parameters. This solution was designed to make audio management more flexible and centralized, so that you don't have to worry about fixing the logical errors of why that town music keeps overlapping itself!. Using a tree-like data structure, when Magic Cassette's internal state is changed *(due to changes somewhere else in the game's variables)*, the manager will traverse the tree to return an Audio Action. This Action determines what is played and how it is played.

The motivation for this project is actually based on a Unity animation solution called [Reanimator](https://github.com/aarthificial/reanimation) by [@aarthificial](https://github.com/aarthificial). His work is so impressive; seriously, go check him out!

### Installation
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
