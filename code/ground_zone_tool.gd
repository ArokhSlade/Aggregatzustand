extends Polygon2D

@export var object_to_spawn: PackedScene
@export var spawn_count: int = 20
@export var ground_scale: float = .45


func _ready():
	spawn_objects_inside_polygon()

func spawn_objects_inside_polygon():
	if polygon.size() < 3 or object_to_spawn == null:
		return

	# triangulation
	var indices: PackedInt32Array = Geometry2D.triangulate_polygon(polygon)
	if indices.is_empty():
		return

	var triangles: Array[Dictionary] = []
	var weights: PackedFloat32Array = []

	for i in range(0, indices.size(), 3):
		var p1: Vector2 = polygon[indices[i]]
		var p2: Vector2 = polygon[indices[i + 1]]
		var p3: Vector2 = polygon[indices[i + 2]]

		var area: float = 0.5 * abs(p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y))

		triangles.append({"p1": p1, "p2": p2, "p3": p3})
		weights.append(area)

	var rng = RandomNumberGenerator.new()

	for _i in range(spawn_count):
		var tri_index: int = rng.rand_weighted(weights)
		var tri: Dictionary = triangles[tri_index]

		var random_point: Vector2 = get_random_point_in_triangle(tri.p1, tri.p2, tri.p3)

		var instance: Node2D = object_to_spawn.instantiate()
		add_child(instance)
		instance.position = random_point
		instance.scale = Vector2(ground_scale,ground_scale)

func get_random_point_in_triangle(p1: Vector2, p2: Vector2, p3: Vector2) -> Vector2:
	var r1: float = sqrt(randf())
	var r2: float = randf()

	var a: float = 1.0 - r1
	var b: float = r1 * (1.0 - r2)
	var c: float = r1 * r2

	return (a * p1) + (b * p2) + (c * p3)
