extends Area2D
class_name temperature_zone

@export var aggregate_state := AggregateStateProfile.Type.WATER
@export var temperature_materials_map : Dictionary[AggregateStateProfile.Type, Material]
@export var particles_map : Dictionary[AggregateStateProfile.Type, Node]

func _ready():
	update_visuals()


func update_visuals():
	$Sprite2D.material = temperature_materials_map.get(aggregate_state)
	update_particles()


func update_particles():
	for particles in $Particles.get_children():
		particles.hide()
	var particles = particles_map.get(aggregate_state)
	if particles:
		var width = .5 * $CollisionShape2D.shape.size.x
		var height = .5 * $CollisionShape2D.shape.size.y
		particles.set_rect_extents(width, height)
		particles.show()


# DEPRECATED
func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		#try_apply_aggregate_state(body)
		pass


func _on_area_entered(area):
	try_apply_aggregate_state(area)


func try_apply_aggregate_state(target):
	if target.has_method("apply_aggregate_state"):
		target.apply_aggregate_state(aggregate_state)
