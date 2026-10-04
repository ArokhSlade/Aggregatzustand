extends "res://level/ground/ground_prototype.gd"

@export var respawn_seconds = 2.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = respawn_seconds


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if not $Ground/Area2D.monitoring and not $Timer.time_left:
		$Timer.start()


func _on_timer_timeout() -> void:
	$Ground/Area2D.monitoring = true
	played_sound = false
	$Ground/StaticBody2D/CollisionPolygon2D.disabled = false
	$Ground/Hexagon.modulate = Color.WHITE
	
