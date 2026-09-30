@tool
extends Polygon2D

@export var object_to_spawn: PackedScene
@export var ground_scale: float = .45

@export var row_spacing: float = 32.0
@export var column_spacing: float = 32.0
@export var max_offset_x: float = 8.0
@export var max_offset_y: float = 8.0
@export_tool_button("Refresh Ground", "Reload") var refresh_ground = respawn_tiles
@export_tool_button("Clear Ground", "Clear") var clear_ground = clear_tiles

const RUNTIME_SPAWN_BATCH_SIZE := 32

var generation_id := 0

func _ready():
	if not Engine.is_editor_hint():
		respawn_tiles()
		color.a = 0


func respawn_tiles():
	generation_id += 1
	var current_generation := generation_id

	for child in get_children():
		child.queue_free()

	if Engine.is_editor_hint():
		spawn_in_rows_immediately()
	else:
		spawn_in_rows_batched(current_generation)


func clear_tiles():
	for child in get_children():
		child.queue_free()


func get_spawn_positions() -> Array[Vector2]:
	var positions: Array[Vector2] = []
	if polygon.size() < 3 || object_to_spawn == null:
		return positions

	var min_pos: Vector2 = polygon[0]
	var max_pos: Vector2 = polygon[0]
	for point in polygon:
		min_pos.x = min(min_pos.x, point.x)
		min_pos.y = min(min_pos.y, point.y)
		max_pos.x = max(max_pos.x, point.x)
		max_pos.y = max(max_pos.y, point.y)

	# Iterate columns first so the runtime batches visibly build left-to-right.
	var x: float = min_pos.x
	while x <= max_pos.x:

		var y: float = min_pos.y
		while y <= max_pos.y:

			var offset := Vector2(
				randf_range(-max_offset_x, max_offset_x),
				randf_range(-max_offset_y, max_offset_y))
			var candidate_pos: Vector2 = Vector2(x, y) + offset

			if Geometry2D.is_point_in_polygon(candidate_pos, polygon):
				positions.append(candidate_pos)
			y += row_spacing

		x += column_spacing

	return positions


func add_ground_instance(spawn_position: Vector2) -> void:
	var instance: Node2D = object_to_spawn.instantiate()
	add_child(instance)
	instance.position = spawn_position
	instance.scale = Vector2(ground_scale, ground_scale)


func spawn_in_rows_immediately() -> void:
	for spawn_position in get_spawn_positions():
		add_ground_instance(spawn_position)


func spawn_in_rows_batched(current_generation: int) -> void:
	var positions := get_spawn_positions()
	for index in positions.size():
		if current_generation != generation_id:
			return

		add_ground_instance(positions[index])
		if (index + 1) % RUNTIME_SPAWN_BATCH_SIZE == 0:
			await get_tree().process_frame
