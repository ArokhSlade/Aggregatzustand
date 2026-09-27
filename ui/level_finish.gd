extends PanelContainer

func open() -> void:
	show()
func close() -> void:
	hide()

signal next_level_selected
signal retry_selected

func _on_next_level_button_pressed() -> void:
	next_level_selected.emit()


func _on_retry_button_pressed() -> void:
	retry_selected.emit()
