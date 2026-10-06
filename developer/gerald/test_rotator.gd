@tool
extends Sprite2D


@export_range(-PI, PI, PI/180.0) var angle_delta := 0.0
@onready var icon: Sprite2D = $"."
@onready var icon_2: Sprite2D = $Icon2

func _process(delta):
	icon_2.global_rotation += angle_delta
