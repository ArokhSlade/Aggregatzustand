extends Node

@export var level_scene : PackedScene
@onready var level_parent = $LevelParent

var level
@onready var menu = $Menu
var current_state : State
var states = {
	"in_game" : InGame.new(self),
	"in_menu" : InMenu.new(self)
}


func _ready():
	load_level()
	enter_initial_state()


func load_level():
	level = level_scene.instantiate()
	level_parent.add_child(level)


func enter_initial_state():
	level.hide()
	states.in_game.on_exit()
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
