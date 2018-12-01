extends Area

var UP_MAX = 0
var DOWN_MAX = 0
enum {GOING_UP, GOING_DOWN}

onready var state = GOING_DOWN
onready var speed = 0.07

func _ready():
	UP_MAX = translation.y
	DOWN_MAX = translation.y - 3

func _on_Area_body_entered(body):
	if(body.name == "player_body"):
		body.get_hurt(5)

func _process(delta):
	if(translation.y >= UP_MAX and state == GOING_UP):
		translation.y -= speed
		state = GOING_DOWN
	elif(translation.y <= DOWN_MAX and state == GOING_DOWN):
		translation.y += speed
		state = GOING_UP
	elif(state == GOING_UP):
		translation.y += speed
	elif(state == GOING_DOWN):
		translation.y -= speed