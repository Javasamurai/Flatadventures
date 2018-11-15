extends Area

var speed = 0
const rot_speed = 0.7

func set_speed(s):
	speed = s

func _physics_process(delta):
	self.translation.x += speed * delta
	self.rotate_z(rot_speed)
	pass

func _on_Knife_body_entered(body):
	body.get_hurt(25)
	queue_free()
