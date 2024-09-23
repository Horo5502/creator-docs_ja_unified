---
sidebar_position: 1
---
# Player API

You can use Udon to retrieve information about players in your world instance.

Udon interacts with Players through the VRCPlayerApi. Each Player has a VRCPlayerApi Object, and your world fires the OnPlayerJoined / OnPlayerLeft events on any UdonBehaviours that listen for them when a player joins or leaves.

This page includes info on using some general player properties and methods. Since there are so many things you can do with the VRCPlayerApi object, we grouped some information together on the following pages:

* [Getting Players](/worlds/udon/players/getting-players)
* [Player Positions](/worlds/udon/players/player-positions)
* [Player Forces](/worlds/udon/players/player-forces)
* [Player Collisions](/worlds/udon/players/player-collisions)
* [Player Audio](/worlds/udon/players/player-audio)
* [Player Avatar Scaling](/worlds/udon/players/player-avatar-scaling)
* [Player Events](/worlds/udon/graph/event-nodes#player-events)

## Generally Useful Properties and Methods

### IsValid
*VRCPlayerApi, Boolean*

Before you try to get or set anything on a Player, check whether IsValid returns true. If a player has left since you saved a reference to them, this will return False. For easier use on the graph, search for the generic "IsValid" method which works for any Object, since it gives you separate flows for True and False.

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs groupId="udon-compiler-language">
<TabItem value="graph" label="Udon Graph">

![An Udon Graph screenshot showing the OnPlayerLeft event connected to an IsValid node.](/img/worlds/player-isvalid.png)

</TabItem>
<TabItem value="cs" label="UdonSharp">

```cs
   public override void OnPlayerLeft(VRCPlayerApi player)  
   {  
	if (Utilities.IsValid(player))
	{
		// Player is valid
	}
	else
	{
		// Player is not valid
	}
}  
```

</TabItem>
</Tabs>



### EnablePickups
*VRCPlayerApi, Boolean*

Turn off the Player's ability to pickup and use VRCPickup objects in the world. This property is *on* by default, so you only need to use the method if you want to turn it off.

### get displayName
*VRCPlayerApi*

Get the name displayed for the Player (can be different than Username, which is used to log into VRChat and not exposed publicly)

### Get isLocal
in: *VRCPlayerApi*

out: *Boolean*

Tells you whether the given Player is the local one.

### Get isMaster
in: *VRCPlayerApi*

out: *Boolean*

Tells you whether the given Player is the [instance master](/worlds/udon/networking#the-instance-master).

### Get isInstanceOwner
in: *VRCPlayerApi*

out: *Boolean*

Tells you whether the given player is the current instance owner.

### Get isSuspended
in: *VRCPlayerApi*

out: *Boolean*

Tells you if the player's device is suspended. A device is suspended if it enters sleep mode or switches to a different app. While suspended, devices don't run Udon code or respond to network events until the player reopens VRChat.

Your code should account for any device becoming suspended at any time, regardless of platform. PC players currently never become suspended, but this should not be assumed.

Note that `isSuspended` is always `false` for the local player - Udon cannot run while the local player is suspended.

### GetPickupInHand
in: *VRCPlayerApi, Hand (none, left, right)*

out: *VRCPickup*

Gets the pickup a Player is holding in the specified hand. Only works for the Local Player. Returns null if no VRCPickup is found.

### IsOwner
in: *VRCPlayerApi, GameObject*

out: *Boolean*

Tells you whether a Player is the Owner of a given GameObject, important for Sync.

### IsUserInVR
in: *VRCPlayerApi*

out: *Boolean*

Tells you whether a Player is using a VR headset.

### PlayHapticEventInHand
*VRCPlayerApi, Hand, float, float, float*

Vibrate the Player's Haptic controllers if they have them. The float inputs should be in the range 0-1. *duration* is the amount of time that they vibrate, *amplitude* is the strength with which they vibrate, and *frequency* is the speed at which they vibrate. The feeling can vary quite a bit between controllers.

### UseAttachedStation
*VRCPlayerApi*

Makes the player get into the Station which is on the same GameObject as this UdonBehaviour.

### SimulationTime
*float*

The [simulation time](/worlds/udon/networking/network-components) of a player.

### UseLegacyLocomotion
*VRCPlayerApi*

**NOT RECOMMENDED** - Turns on legacy locomotion for this player, mimicking how players moved in VRChat's deprecated SDK2. After enabling legacy locomotion, it stays enabled until the user leaves your world.

## Language

### GetCurrentLanguage
*string*

Gets the selected language of the local user. The value is formatted in the RFC 5646 syntax. (`en`, `ja`, `es`, `zh-CN`, etc.)

### GetAvailableLanguages
*string[]*

Gets all available languages a player can select in VRChat's settings. The value is formatted in the RFC 5646 syntax. (`en`, `ja`, `es`, `zh-CN`, etc.)