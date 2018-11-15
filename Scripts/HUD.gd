extends Control

const boy = preload("res://Assets/pngs/boy_head.png")
const girl = preload("res://Assets/pngs/girl_head.png")

func _ready():
	if(GlobalConstants.SELECTED_PLAYER == GlobalConstants.NINJA_BOY):
		$HBoxContainer/TextureRect.set_texture(boy)
	else:
		$HBoxContainer/TextureRect.set_texture(girl)
