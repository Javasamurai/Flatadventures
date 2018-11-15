extends Spatial

func _process(delta):
	$Camera.translation.x = $player_body.translation.x
	$Camera.translation.y = $player_body.translation.y + 5