# Magic Cassette (for Godot)
## *a lightweight solution to audio management*
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

For our example how to fill this configuration file, we're going to set up our manager for ***playing music in a fantasy town.*** This is a made up example, and not the example that is reflected in the files. With enough interest, I can defintely bring the example to life though!

### TLDR
1. Move `AudioManager` into project folder.
2. Autoload `audio_manager.tscn` in Project Settings (place it *after* any globals)
3. Fill out `audio.cfg`

## `Tracks`
**Tracks** are objects that store:
- an **alias**
- an audio file path
- the BPM (Beats Per Minute)
- the Total Beats (in the song)

A good rule of thumb is to give your audio track names consistent. "*untitled(3).mp3*" isn't the best name for your dungeon music.

The configuration file reads a **Track** as follows:
```js
track_name = [bpm, total_beats, <"audio_file_path">]

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
action_name = {"audio_control_method" : {"track_name" : {[extra_parameters_for_the_track]} } }

#Note: Extra parameters can simply be left as an empty dictionary: {}, this defaults the audio to loop.
```
Now, I need to create **Actions** for all of the **Tracks** I want to play.
```js
[Actions]
play_overworld = {"play" : {"overworld" : {} } }
play_item_shop = {"play" : {"item_shop" : {} } }
play_castle = {"play" : {"castle" : {} } }
```
Again, ***think of the syntax as an abstract sentence, with each word being contained within its own dictionary.***

Oh wait. I forgot... my castle theme has an intro that doesn't loop well! There are two ways to fix this. Let's say I want to separate my castle theme into two files: `castle_intro` and `castle_loop`. Let me show how this fix would look in `audio.cfg`.

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

Another thing to note is that you can have **multiple audio control methods** in one **Action**, simply add another method as a dictionary key and go from there.

## `State Variables`
**State Variables** are objects that store:
- **aliases** corresponding to variable names (variables that are intended to change the *state* of the audio)
- a path to a scene node
- the name of a function that can retrieve the variable at runtime

...The example will clear things up.

The configuration file reads a **State Variable** as follows:
```js
variable_name = ["absolute_path_to_node", "method_name_to_get_variable"]

#Note: No optional parameters here. Make sure your path includes and begins with "/root/"
```

In our example, we said that we only changed the music based on the town location of the player. Let's say I've set up a variable to keep track of the player's location in a Singleton node called `globals`. Then I will fill out `audio.cfg` like this:
```js
[State Variables]
current_location = ["/root/globals", "get_location"]
```

As long as we've made sure there is a method `get_location()` in `globals`, the audio manager will have no trouble retrieving this value during the runtime of the game.

## `Trees`
**Trees** are objects that store:
- an **alias**
- a nested dictionary abstraction of a tree-like structure, using **State Variables** as tree roots and subtree roots, and **Actions** as leaves

All of the logic happens in these **Trees**, and you'll notice the syntax to be similar to that of **Actions**.

The configuration file reads a **Tree** as follows:
```js
tree_name = {"state_variable_name":{"possible_value":{"next_state_variable_name":{"another_value":{... : "action_name"} } } } }
```
**Note: You absolutely MUST have your tree_name as `root`**. You are able to store as many **Trees** as you want, but `root` will always be the only **Tree** being evaluated. Later on, I would like the inclusion of multiple trees to lead to more organized work, but for now additional trees will not cause any changes.

 \**ahem\** Back to the example, let's create our logic tree for our town.
 ```js
 [Trees]
 root = { "current_location" : {"overworld" : "play_overworld", "item_shop" : "play_item_shop", "castle" : "play_castle"}
 ```
Here's a visualization of the tree:
```js
Root:
                                     current_location
                                     
            /                               |                               \
           /                                |                                \
          /                                 |                                 \
         /                                  |                                  \
        |"overworld" -> play_overworld|     |"item_shop" -> play_item_shop|     |"castle" -> play_castle| 
        
```
More complex tree structures are definitely possible, just keep in mind that tree roots are always **State Variables**, and their corresponding values in the tree will ever only have **one** child, *either an* **Action**, *or a subtree with a* **State Variable** *as its root*.

## `Completed Configuration File`

```js
audio.cfg
---------

[Tracks]
overworld = [100, 120, "res://audio/bgm/overworld.mp3"]
item_shop = [80, 32, "res://audio/bgm/buildings/item_shop.ogg"]
castle_intro = [120, 4]
castle_loop = [120, 28]

[Actions]
play_overworld = {"play" : {"overworld" : {} } }
play_item_shop = {"play" : {"item_shop" : {} } }
play_castle = {"play" : {"castle_intro" : {"on_end" : "next", "next_song" : "castle_loop"}

[State Variables]
current_location = ["/root/globals", "get_location"]

[Trees]
root = { "current_location" : {"overworld" : "play_overworld", "item_shop" : "play_item_shop", "castle" : "play_castle"}
```
And just like that, you've successfully set up a state-esque machine that will handle your music for you in one file.

### Conclusion
**Magic Cassette** is a work in progress, and I would love any feedback on how to improve the manager. Some things I have in mind right now are:
- More integration for sound effects
- Better error handling
- Even more action control methods (adding filters, Method 2 mentioned above, changing AudioStreams to AudioStream2D or 3D for more flexibility)
- Allowing more than one tree to be processed at a time (to allow for multiple different sounds to play at the same time)
- Potentially better ways to retrieve **State Variables** without relying on adding methods to specified scene nodes
- Building this manager for Unity

Thanks, and happy developing!

---
## Magic Cassette API
### Track Parameters

### `on_start`
#### *Status*: <span style="color:limegreen">Implemented</span> :heavy_check_mark:
#### *Description*
At the start of the track, perform any method(s).  

| Methods |
| --------- |
| `fade_in` |
| `play`    |
| `goto_position` |

#### *Method Descriptions*

#### *Example*


---
### `on_end`
#### *Status*: <span style="color:limegreen">Implemented</span> :heavy_check_mark:
#### *Description*
At the end of the track, perform any method(s).

| Methods |
| ------ |
| `loop` |
| `stop` |
| `next` |

#### *Method Descriptions*

#### *Example*


---
### `beats_to_emit_signal`
#### *Status*: <span style="color:limegreen">Implemented</span> :heavy_check_mark: <span style="color:darkgray">(to be changed to `on_beat`)</span>
#### *Description*
Emits the signal `music_cue(beat)` to given objects with the connection method `_on_music_cue(beat)`

#### *Example*


---
### `next_song`
#### *Status*: <span style="color:limegreen">Implemented</span> :heavy_check_mark: <span style="color:darkgray">(to be added as a method to `on_start` and `on_end`'s method: `next`)</span>
#### *Description*

#### *Example*


---
### `next_song_params`
#### *Status*: <span style="color:limegreen">Implemented</span> :heavy_check_mark: <span style="color:darkgray">(to be combined with `next_song`)</span>
#### *Description*

#### *Example*


---
### `other_callback`
#### *Status*: <span style="color:limegreen">Implemented</span> :heavy_check_mark: <span style="color:darkgray">(to be added as a method for `on_start` and `on_end`)</span>
#### *Description*

#### *Example*


---
### Audio Actions

### `play`
#### *Status*: <span style="color:limegreen">Implemented</span> :heavy_check_mark:
#### *Description*

#### *Example*


---
### `add`
#### *Status*: <span style="color:red">Not Yet Implemented</span> :x:
#### *Description*

#### *Example*


---
### `fade_in`
#### *Status*: <span style="color:red">Not Yet Implemented</span> :x:
#### *Description*

#### *Example*


---
### `fade_out`
#### *Status*: <span style="color:limegreen">Implemented</span> :heavy_check_mark:
#### *Description*

#### *Example*


---
### `transition_to`
#### *Status*: <span style="color:limegreen">Implemented</span> :heavy_check_mark:
#### *Description*

#### *Example*


---
### `cut_to`
#### *Status*: <span style="color:red">Not Yet Implemented</span> :x:
#### *Description*

#### *Example*


---
### `play_sfx`
#### *Status*: <span style="color:red">Not Yet Implemented</span> :x:
#### *Description*

#### *Example*






