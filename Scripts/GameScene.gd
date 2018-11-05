extends Spatial

func _process(delta):
	$Camera.translation.x = $KinematicBody.translation.x
	$Camera.translation.y = $KinematicBody.translation.y + 5