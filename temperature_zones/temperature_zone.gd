extends Area2D
class_name temperature_zone

@export var aggregate_state := AggregateStateProfile.Type.WATER
@export var temperature_materials_map : Dictionary[AggregateStateProfile.Type, Material]
@export var particles_map : Dictionary[AggregateStateProfile.Type, PackedScene]


func _ready():
	update_visuals()


func update_visuals():
	$Sprite2D.material = temperature_materials_map.get(aggregate_state)
	update_particles()


func update_particles():
	var particles = particles_map.get(aggregate_state)
	if not particles:
		return
	particles = particles.instantiate()
	var half_extents = get_half_extents()
	particles.set_rect_extents(half_extents.x, half_extents.y)
	add_child(particles)


func _on_area_entered(area):
	try_apply_aggregate_state(area)


func try_apply_aggregate_state(target):
	if target.has_method("apply_aggregate_state"):
		target.apply_aggregate_state(aggregate_state)
 

func get_half_extents():
	var half_extents = .5 * $CollisionShape2D.shape.size
	return half_extents
