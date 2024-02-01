Godot states
============


Wait... an other state machine plugin for godot ?
-----------------------------------------------

Yes... and no ! What's special about this plugin is that, unlike the typical state machine design pattern, it uses only *states* and is therefore extremely simple to implement.
More precisely, this plugin provides three classes that allow you to manage the behavior of your nodes in great detail and in a **visual** way. 


Let's take a closer look to them.

Quick Presentation
---------------------

### The State node

This is the most basic node, and yet a very powerful one. Even if it can be used as part a state machine pattern (more on that later), it can also be added as direct child of any common node in order to extend its functionnality. It allows to split the logic of the node in multiple, maintainable *traits* that can then be reused in other nodes.
For instance, you can choose to make a *HorizontalMoveState* that moves a Kinematic horizontally, a *JumpState* that makes it jump, and a *GravityState* that makes it subject to gravity.
Therefore, if the player is under a very low ceil, jump can be disabled (by disabling or removing the *JumpState*). If it is space, gravity can be canceled etc. 

**And more importantly** : you can make other nodes (that won't move like the previous Kinematic) still affected by gravity by reusing the GravityState on them.

But the State node really shines when combined with the **StackedState** and the **SwitchableState**

### The SwitchableState node

This is somewhat equivalent to a state machine, with the exception that **it inherits from the State node** and can be used the same way. This node is designed to receive multiple States as children and to run **only one** at a time (the first child being run by default). It provides and `change_state` method to switch from one state to another.

### The StackedState node

the StackedState **also inherits from State node** is also designed to receive children but unlike the SwitchableSate, it will run **all** of its children. States will be **stacked** on top of each other, the first children being the first processed.

This approach starts to be interesting when you realize that this nodes are States and thus can be intricated inside each other. One of the most common pattern is to **have multipe StackedState node as child of SwitchableState** which allow to run entire groups of State at a time. Actually, you can structure all your behaviours as a logical *tree* and save entire branches as scene to reuse them in other branches.


