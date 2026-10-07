# Aggregatzustand
## made at InnoGames Gamejam #17
## Credits
* Lizzy
* Tommy
* Henrik
* Sasha
* Juan
* Gerald

# Code Structure
## Bubble2
Aggregate states are expressed mostly by switching material and gravity scale.
State pattern is used to modify transforms of sprite and physics body as needed.

<table>
<tr>
	<td>
		_Steamy_ rotates, then stabilizes,<br/>
		implemented also by state pattern.
	</td>
	<td>
		<img src="/readme/water to gas fixed.gif"/>
	</td>	
</tr>
<tr>
	<td>
		_Watery_ aligns the physics body to the sprite,<br/>
		via _integrate_forces().
	</td>
	<td>
		<img src="/readme/gas to water fixed.gif"/>
	</td>
</tr>
</table>