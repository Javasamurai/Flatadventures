extends Node2D

func _on_boy_button_up():
	GlobalConstants.SELECTED_PLAYER = GlobalConstants.NINJA_BOY
	get_tree().change_scene("res://Scenes/GameScene.tscn")


func _on_girl_button_up():
	GlobalConstants.SELECTED_PLAYER = GlobalConstants.NINJA_GIRL
	get_tree().change_scene("res://Scenes/GameScene.tscn")


func _on_boy_mouse_entered():
	$Control/HBoxContainer/boy.set_scale(Vector2(1.1,1.1))


func _on_girl_mouse_entered():
	$Control/HBoxContainer/girl.set_scale(Vector2(1.1,1.1))


func _on_boy_mouse_exited():
	$Control/HBoxContainer/boy.set_scale(Vector2(1,1))


func _on_girl_mouse_exited():
	$Control/HBoxContainer/girl.set_scale(Vector2(1,1))
