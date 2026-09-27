extends Node

## level to be loaded
@export var level_scenes : Array[PackedScene]
var level_index = 0

## Resource that defines balancing values for aggregate states
@export var aggregate_states_resoure : AggregateStateProfile

@onready var level_parent = $LevelParent
@onready var menu = $Menu
@onready var endscreen = $LevelFinish

var level
var current_state : State
var states = {
	"in_game" : InGame.new(self),
	"in_menu" : InMenu.new(self),
	"in_end_screen" : InEndScreen.new(self)
}


func _ready():
	load_level()
	enter_initial_state()


func load_level():
	level = level_scenes[level_index].instantiate()
	level.initialize(aggregate_states_resoure)
	level.connect("level_finished",on_level_finished)
	level_parent.add_child(level)


func enter_initial_state():
	endscreen.hide()
	level.hide()
	states.in_game.on_exit()
	states.in_end_screen.on_exit()
	current_state = states.in_menu
	current_state.on_enter()


func _input(event : InputEvent):
	if event is InputEventAction:
		print("action!")
	current_state.on_input(event)


func switch_state_to(state_):
	if state_ == current_state:
		return
	current_state.on_exit()
	current_state = state_
	current_state.on_enter()


func quit_game():
	get_tree().quit()


func _on_menu_play_requested():
	switch_state_to(states.in_game)


func _on_menu_quit_requested():
	quit_game()

func on_level_finished() -> void:
	switch_state_to(states.in_end_screen)

func on_retry_selected() -> void:
	level.queue_free()
	load_level()
	switch_state_to(states.in_game)

func on_next_level_selected() -> void:
	level.queue_free()
	level_index += 1
	load_level()
	switch_state_to(states.in_game)


@abstract class State:
	var owner
	
	@abstract func on_input(_event)
	@abstract func on_enter()
	@abstract func on_exit()
	
	func _init(owner_):
		owner = owner_


class InGame extends State:
	func on_input(event):
		if event.is_action_released("ui_cancel"):
			owner.switch_state_to(owner.states.in_menu)
	
	
	func on_enter():
		owner.level.unpause()
		owner.level.show()
		PokiSDK.gameplay_start()
	
	
	func on_exit():
		owner.level.pause()
		PokiSDK.gameplay_stop()
		#PokiSDK.commercial_break()


class InMenu extends State:
	func on_input(event : InputEvent):
		if event.is_action_released("ui_cancel"):
			owner.switch_state_to(owner.states.in_game)
	
	
	func on_enter():
		owner.menu.open()
	
	func on_exit():
		owner.menu.close()

class InEndScreen extends State:
	func on_input(_event):
		pass
	func on_enter():
		owner.endscreen.open()
	
	func on_exit():
		owner.endscreen.close()