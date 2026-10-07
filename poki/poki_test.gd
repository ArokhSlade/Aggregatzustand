extends Control


func _on_gameplay_start_pressed():
	PokiSDK.gameplay_start()


func _on_gameplay_stop_pressed():
	PokiSDK.gameplay_stop()


func _on_commercial_ad_pressed():
	PokiSDK.commercial_break()
