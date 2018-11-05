extends KinematicBody

export (int) var run_speed
export (int) var jump_speed
export (int) var gravity

const boy = preload("res://Scenes/ninjaboy.tscn")
const girl = preload("res://Scenes/ninjagirl.tscn")

enum {IDLE, RUN, JUMP_UP, FALL_DOWN, ATTACK}
var velocity = Vector3(0,0,0)
var state
var player
var anim
var new_anim
var anim_player

func _ready():
	if(GlobalConstants.SELECTED_PLAYER == GlobalConstants.NINJA_BOY):
		player = boy.instance()
	else:
		player = girl.instance()
	add_child(player)
	anim_player = player.get_node("AnimationPlayer")
	anim_player.connect('animation_finished', self, 'animation_completed')
	change_state(IDLE)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			new_anim = 'idle'
		RUN:
			new_anim = 'run'
		JUMP_UP:
			new_anim = 'jump_up'
		FALL_DOWN:
			new_anim = 'fall_down'
		ATTACK:
			new_anim = 'attack'

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_up')
	var attack = Input.is_action_just_pressed('attack')

	if jump and is_on_floor():
		change_state(JUMP_UP)
		velocity.y = jump_speed
	if right:
		if(is_on_floor()):
			change_state(RUN)
		velocity.x += run_speed
		$Player.flip_h = velocity.x < 0
	if left:
		if(is_on_floor()):
			change_state(RUN)
		velocity.x -= run_speed
		$Player.flip_h = velocity.x < 0
	if attack:
		if(is_on_floor()):
			change_state(ATTACK)
			set_process(false)
			velocity.x = 0

	if !right and !left and state == RUN:
		change_state(IDLE)

func animation_completed(anim):
	if(anim == 'attack'):
		set_process(true)

func _process(delta):
	get_input()
	if(anim_player == null):
		return
	if new_anim != anim:
		anim = new_anim
		anim_player.play(anim,-1,2)

func _physics_process(delta):
	velocity.y += gravity * delta
	if state == FALL_DOWN:
		if is_on_floor():
			change_state(IDLE)
	if(velocity.y < 0 and !is_on_floor()):
		change_state(FALL_DOWN)
	elif(velocity.y > 0 and !is_on_floor()):
		change_state(JUMP_UP)
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
