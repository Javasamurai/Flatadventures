extends Node2D

func _ready():
	pass


func _on_PlayGame_button_up():
	get_tree().change_scene("res://Scenes/SelectionScreen.tscn")

func _on_Credits_button_up():
	get_tree().change_scene("res://Scenes/credits.tscn")

func _on_Exit_button_up():
	get_tree().quit()

