extends KinematicBody

export (int) var run_speed
export (int) var attack_hurt
export (int) var gravity
export (NodePath) var front_pos_path
export (NodePath) var back_pos_path

enum {WALK, RUN, ATTACK, DEAD}
var velocity = Vector3(0, 0, 0)
var state
var anim
var new_anim
onready var anim_player = $enemy_sprite/AnimationPlayer

var front_pos
var back_pos
var player
var health = 100

func _ready():
	add_to_group(GlobalConstants.ENEMIES)
	change_state(WALK)
	front_pos = get_transform().origin.x + calc_dist_to(get_node(front_pos_path).get_global_transform().origin.x)
	back_pos = get_transform().origin.x + calc_dist_to(get_node(back_pos_path).get_global_transform().origin.x)
	anim_player.connect('animation_finished', self, 'animation_completed')

func calc_dist_to(x):
	return x - get_transform().origin.x

func animation_completed(anim):
	if anim == 'attack':
		attack_player()
		change_state(WALK)
	elif(anim == "dead"):
		set_process(false)
		set_physics_process(false)

func change_state(new_state):
	state = new_state
	match state:
		WALK:
			new_anim = 'walk'
		RUN:
			new_anim = 'run'
		ATTACK:
			new_anim = 'attack'
		DEAD:
			new_anim = 'dead'

func _process(delta):
	if(anim_player == null):
		return
	if new_anim != anim:
		if(new_anim == 'dead'):
			print("die anim")
		anim = new_anim
		anim_player.play(anim,-1,2)

func _physics_process(delta):
	if(state == DEAD):
		return
	if($enemy_sprite.flip_h):
		if(get_transform().origin.x > back_pos):
			turn_left()
		else:
			turn_right()
	else:
		if(get_transform().origin.x < front_pos):
			turn_right()
		else:
			turn_left()
	velocity.y += gravity
	velocity = move_and_slide(velocity)
	var kin_coll = get_slide_collision(get_slide_count() - 1)
	if(kin_coll and kin_coll.get_collider().name == 'player_body'):
		player = kin_coll.get_collider()
		if(player.state != player.DEAD):
			change_state(ATTACK)
	else:
		change_state(WALK)

func turn_left():
	velocity.x = -run_speed
	$enemy_sprite.flip_h = true
	$enemy_sprite.set_offset(Vector2(-50, 0))

func turn_right():
	velocity.x = run_speed
	$enemy_sprite.flip_h = false
	$enemy_sprite.set_offset(Vector2(50, 0))

func attack_player():
	player.get_hurt(attack_hurt)

func get_hurt(hurt):
	health -= hurt
	if(health <= 0):
		die()

func die():
	change_state(DEAD)

