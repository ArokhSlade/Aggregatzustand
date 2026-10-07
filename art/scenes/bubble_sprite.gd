@tool
extends Sprite2D

func _get_configuration_warnings():
	var warnings = []

	if scale != Vector2.ONE:
		warnings.append("Non-default Scale! To change the size, prefer to adjust the texture dimensions, rather than the transform.\n This avoids having to deal with transfrom issues down the line.")

	return warnings
