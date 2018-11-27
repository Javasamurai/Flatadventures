extends Node2D

var seconds_passed = 0
func _ready():
	get_node("lives").text = "x" + str(GlobalConstants.lives)
	if GlobalConstants.SELECTED_PLAYER == GlobalConstants.NINJA_BOY:
		get_node("Sprite").texture = load("res://Assets/pngs/boy_head.png")
	else:
		get_node("Sprite").texture = load("res://Assets/pngs/girl_head.png")
	pass
	if GlobalConstants.lives <=0:
		get_node("lives").text = "Game Over"
		set_process(false)

func _process(delta):
	seconds_passed = seconds_passed + delta
	print(seconds_passed)
	if seconds_passed > 1.5:
		get_tree().change_scene("res://Scenes/GameScene.tscn")
func load_game():
	print("Timout")
