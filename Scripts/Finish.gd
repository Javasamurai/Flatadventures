extends Area

func _ready():
	pass


func _on_Finish_body_entered(body):
	if(body.name == 'player_body'):
		print('finish entered')
		body.stop_movement()
