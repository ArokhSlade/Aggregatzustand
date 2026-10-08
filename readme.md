# Aggregatzustand

## made at InnoGames Gamejam #17
with extensive code refactor afterwards and some content upgrades.
## Credits
* Lizzy - Game Design
* Tommy - Programming, Sound, Music, Tech Art
* Henrik - Programming
* Sasha - Art: Schnuffi, Environments
* Juan - Art: Bubble, VFX, Tech Art
* Gerald - Programming

# Code Structure

## [Bubble](/player/bubble.gd)
Aggregate states are expressed visually by switching material and functionally via gravity scale.  
State pattern is used to modify transforms of sprite and physics body as needed.

<table>
<tr>
	<td>
		<i>Steamy</i> rotates, then stabilizes,<br/>
		implemented also by state pattern.
	</td>
	<td>
		<img src="/readme/water to gas fixed.gif"/>
	</td>	
</tr>
<tr>
	<td>
		<i>Watery</i> aligns the physics body to the sprite,<br/>
		via _integrate_forces().
	</td>
	<td>
		<img src="/readme/gas to water fixed.gif"/>
	</td>
</tr>
</table>

## BubbleOld
The more complex first iteration with these non-essentials:
- an aggregate states profile - a resource that defines a curve mapping temperature to gravity scale - potential for more complex game design; not used.
- nested prototype objects allow customizing visuals directly where they are used. Useful for transform offsets if desired.
- the discrete aggregate states system actually used in the game was realized by mapping aggregate state enums to temperature values.

# Coding Conventions

## Initialization
Dependencies are injected top-down via initialize(), which calls initialize() on children.
Initialize() shall be callable before _ready().
This allows initializing newly instantiated objects before they are added to the tree.
This allows a spawner instantiating an item and signaling it up to someone to decide where to insert it into the tree.
This means @on_ready variables are not available. Alernative: $-syntax / get_node().