extends PanelContainer

signal play_requested
signal quit_requested

func open():
	show()


func close():
	hide()


func _on_play_button_pressed():
	play_requested.emit()


func _on_quit_button_pressed():
	quit_requested.emit()
