extends CPUParticles2D

@export_range(0.0001, 0.05, 0.0001) var particle_density : float :
	set(value):
		particle_density = value
		update_amount()
	get:
		return particle_density

func update_amount():
	var area = emission_rect_extents.x * emission_rect_extents.y
	amount = maxi(1,roundf(area * particle_density))
	print(amount)


func set_rect_extents(w,h):
	emission_rect_extents.x = w
	emission_rect_extents.y = h


func _ready():
	update_amount()
