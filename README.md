# Godot Utility AI example

In this example I implemented a simple utility AI using Godot's node system.

The utility AI nodes are inside `./addons/utility_ai`. Examples using those nodes can be found inside `./example`.

Assets used: [fantasy_](https://analogstudios.itch.io/fantasy) by [analogStudios_](https://analogstudios.itch.io/).


## What is a Utility AI

A utility AI, also called utility systems, is a decision making algorithm used in game AI. It works by calculating the utility
of each action and choosing the one with best score. I created this example for this [video](https://youtu.be/d63hbJYYqM8) which explains it in more detail.

In summary, the NPC has a set of actions. Each action should have one or more considerations. A consideration is scored as a number between 0 and 1.0, and a formula (curve) is applied to it to generate the utility score.

When multple considerations are defined for an action they should be aggregated in some way. Usually the scores are multiplied, but you can also calculate them in other ways, such as sum, average, min or max.

Utility AI focus on the decision making, so once the most useful action is defined, you are the one deciding how to execute it.

### Node structure

These are the basic nodes I created for this implementation:

`UtilityAiAgent`: This is the node where you set all actions available for your NPC. It notifies when the top action changes via a signal and you
can also get the list of all actions with the latest scores.

`UtilityAiAction`: This represents an action. It accepts a custom id or it uses the node name as identifier. Considerations should be nested inside it.

`UtilityAiConsideration`: Base consideration class. Here you define the curve for the consideration and you should add your custom score logic inside the score method.
I also implemented `UtilityAiConsiderationFromNode`, which is a custom consideration which accepts a node and a custom property or method name to be used in the consideration.

`UtilityAiAggregation`: If you need to use multiple considerations for an action, you need to aggregate them using this node. You can choose how the aggregation should be done (sum, multiplication, max, min, average).

The structure would look like this:

```
- UtilityAiAgent
  - UtilityAiAction
    - UtilityAiConsideration
  - UtilityAiAction
    - UtilityAiAggregation
      - UtilityAiConsideration
      - UtilityAiConsideration
```


## The example

This project uses the basic nodes mentioned above to implement a simple ai.

If you run the project the main example will be executed by default. There is also a `multiple_npcs.tscn` that shows multiple Utility AI agents working.

Inside `example/ai/considerations` you will find a couple of examples extending the consideration node for custom logic.

### The logic

In this example the NPC has the following actions available: Idle, Eat, Sleep, Find Food, Look for Shelter and Relax. 

"Idle" has a constant utility score. It's the default action when there is nothing more important.

The NPC has 3 meters: hunger, energy and stress.

The hunger meter increases constantly and can only be filled by executing the "Eat" action. This action can only happen if the NPC is holding food.

The "Find food" action is executed when there is food available and the NPC is hungry. This needs to happen before eating.

The energy meter decreases constantly. The NPC can only recover by sleeping. For the Sleep action to be triggered the NPC needs to be in a safe zone, which is close to the firepit. When energy is low and the NPC is far from the firepit, the "Look for shelter" action utility will be high.

The stress meter increases when the NPC is far from the firepit. If this meter gets too high the "Find shelter" action score increases, making the NPC run to the firepit, where the "Relax" action utility should be high enough to be executed.

There are a few details on how I calculate the scores. I cover them in my video. I might improve this readme if I find time for it.


## Questions and contact

If you have any questions feel free to raise an issue in this PR, send a comment in my video or contact me on [Mastodon](https://mastodon.gamedev.place/@thisisvini).

Check my website [thisisvini.com](https://thisisvini.com/) for updated contact methods or more info.

