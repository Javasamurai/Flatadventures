extends Spatial

func _process(delta):
	$Camera.translation.x = $player_body.translation.x
	$Camera.translation.y = $player_body.translation.y + 2
	if $Camera.translation.y <= -10:
		GlobalConstants.lives = GlobalConstants.lives - 1
		get_tree().change_scene("res://Scenes/lives.tscn")
