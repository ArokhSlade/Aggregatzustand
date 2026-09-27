extends Area2D
class_name temperature_zone

@export var aggregate_state := AggregateStateProfile.Type.WATER
@export var temperature_materials : Dictionary[AggregateStateProfile.Type, Material]

func _ready():
	update_visuals()


func update_visuals():
	$Sprite2D.material = temperature_materials.get(aggregate_state)
	

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
