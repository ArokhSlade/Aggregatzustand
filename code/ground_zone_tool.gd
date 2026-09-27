@tool
extends Polygon2D

@export var object_to_spawn: PackedScene
@export var ground_scale: float = .45

@export var row_spacing: float = 32.0
@export var column_spacing: float = 32.0
@export var max_offset_x: float = 8.0
@export var max_offset_y: float = 8.0

func _ready():
	respawn_tiles()
	color.a = 0

@export_tool_button("Refresh Ground", "Reload") var refresh_ground = respawn_tiles

func respawn_tiles():
	for child in get_children():
		child.queue_free()
	
	spawn_in_rows()


func spawn_in_rows():
	if polygon.size() < 3 || object_to_spawn == null:
		return

	var min_pos: Vector2 = polygon[0]
	var max_pos: Vector2 = polygon[0]
	for point in polygon:
		min_pos.x = min(min_pos.x, point.x)
		min_pos.y = min(min_pos.y, point.y)
		max_pos.x = max(max_pos.x, point.x)
		max_pos.y = max(max_pos.y, point.y)

	var y: float = min_pos.y
	while y <= max_pos.y:

		var x: float = min_pos.x
		while x <= max_pos.x:

			var offset := Vector2(
				randf_range(-max_offset_x, max_offset_x),
				randf_range(-max_offset_y, max_offset_y))
			var candidate_pos: Vector2 = Vector2(x, y) + offset

			if Geometry2D.is_point_in_polygon(candidate_pos, polygon):
				var instance: Node2D = object_to_spawn.instantiate()
				add_child(instance)
				instance.position = candidate_pos
				instance.scale = Vector2(ground_scale, ground_scale)
			x += column_spacing

		y += row_spacing
