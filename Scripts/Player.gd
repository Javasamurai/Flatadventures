extends KinematicBody

export (int) var run_speed
export (int) var jump_speed
export (int) var gravity

const boy = preload("res://Scenes/ninjaboy.tscn")
const girl = preload("res://Scenes/ninjagirl.tscn")
const knife = preload("res://Scenes/Knife.tscn")

enum {IDLE, RUN, JUMP_UP, DOUBLE_JUMP, FALL_DOWN, ATTACK, THROW, JUMP_ATTACK, JUMP_THROW, DEAD, FINISH}

var velocity = Vector3(0, 0, 0)
var state
var player
var anim
var new_anim
var anim_player
var jump_time = 0

var health = 100
onready var health_bar = get_parent().get_node('HUD/HBoxContainer/TextureProgress')
var sword_area

func _ready():
	if(GlobalConstants.SELECTED_PLAYER == GlobalConstants.NINJA_BOY):
		player = boy.instance()
	else:
		player = girl.instance()
	add_child(player)
	anim_player = player.get_node("AnimationPlayer")
	anim_player.connect('animation_finished', self, 'animation_completed')
	change_state(IDLE)
	health_bar.set_value(health)
	sword_area = player.get_node("Area")
	sword_area.connect("body_entered", self, "on_sword_attack")

func on_sword_attack(body):
	if(body.is_in_group(GlobalConstants.ENEMIES)):
		body.get_hurt(50)

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
		THROW:
			new_anim = 'throw'
		DOUBLE_JUMP:
			new_anim = 'double_jump'
		JUMP_ATTACK:
			new_anim = 'jump_attack'
		JUMP_THROW:
			new_anim = 'jump_throw'
		DEAD:
			new_anim = 'dead'

func get_input():
	if(state == FINISH):
		return
	velocity.x = 0
	var right = Input.is_action_pressed('move_right')
	var left = Input.is_action_pressed('move_left')
	var jump = Input.is_action_just_pressed('jump')
	var attack = Input.is_action_just_pressed('attack')
	var throw = Input.is_action_just_pressed('throw')

	if jump:
		if is_on_floor():
			change_state(JUMP_UP)
			velocity.y = jump_speed
			jump_time = jump_time + 1
		elif jump_time == 1:
			jump_time = 0
			change_state(JUMP_UP)
			velocity.y = jump_speed

	if right:
		if is_on_floor():
			change_state(RUN)
		velocity.x += run_speed
		$Player.flip_h = false
		sword_area.set_scale(Vector3(1, 1, 1))
	if left:
		if is_on_floor():
			change_state(RUN)
		velocity.x -= run_speed
		$Player.flip_h = true
		sword_area.set_scale(Vector3(-1, 1, 1))
	if attack:
		attack_enemy()
	if throw:
		if is_on_floor():
			change_state(THROW)
			set_process(false)
			velocity.x = 0
			throw_knife()
		else:
			change_state(JUMP_THROW)
			throw_knife()

	if !right and !left and state == RUN:
		change_state(IDLE)

func animation_completed(anim):
	if anim == 'attack' or anim == 'throw' or anim == 'jump_attack' or anim == 'jump_throw':
		set_process(true)
		change_state(IDLE)
	elif anim == 'dead':
		GlobalConstants.lives = GlobalConstants.lives - 1
		get_tree().change_scene("res://Scenes/lives.tscn")
		set_physics_process(false)
		set_process(false)

func throw_knife():
	var knife_inst = knife.instance()
	var speed
	if $Player.flip_h: 
		speed = -20
		knife_inst.translate(Vector3(1, 0, 0))
	else:
		speed = 20
		knife_inst.translate(Vector3(-1, 0, 0))
	knife_inst.set_speed(speed)
	add_child(knife_inst)

func _process(delta):
	get_input()
	
	if(anim_player == null):
		return
	if new_anim != anim:
		anim = new_anim
		anim_player.play(anim,-1,2)


func _physics_process(delta):
	if(state == DEAD):
		return
	velocity.y += gravity * delta
	if state == FALL_DOWN:
		if is_on_floor():
			change_state(IDLE)
	if(state != JUMP_ATTACK and state != JUMP_THROW):
		if(velocity.y < 0 and !is_on_floor()):
			change_state(FALL_DOWN)
		elif(velocity.y > 0 and !is_on_floor()):
			change_state(JUMP_UP)
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))

func get_hurt(hurt):
	health -= hurt
	health_bar.set_value(health)
	if(health <= 0):
		change_state(DEAD)
		$CollisionShape.disabled = true

func attack_enemy():
	if is_on_floor():
		change_state(ATTACK)
		set_process(false)
		velocity.x = 0
	else:
		change_state(JUMP_ATTACK)

func stop_movement():
	change_state(FINISH)
	set_physics_process(false)
	if(GlobalConstants.CURR_LEVEL != 3):
		GlobalConstants.CURR_LEVEL += 1
		get_tree().reload_current_scene()