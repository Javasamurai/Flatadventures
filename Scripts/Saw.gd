extends Area

var LEFT_MAX = 0
var RIGHT_MAX = 0
enum {GOING_LEFT, GOING_RIGHT}

onready var state = GOING_LEFT
onready var speed = 0.1
export (int) var dist = 5

func _ready():
	LEFT_MAX = translation.x
	RIGHT_MAX = translation.x + dist

func _on_Area_body_entered(body):
	if(body.name == "player_body"):
		body.get_hurt(5)

func _process(delta):
	if(translation.x >= RIGHT_MAX and state == GOING_RIGHT):
		translation.x -= speed
		state = GOING_LEFT
	elif(translation.x <= LEFT_MAX and state == GOING_LEFT):
		translation.x += speed
		state = GOING_RIGHT
	elif(state == GOING_RIGHT):
		translation.x += speed
	elif(state == GOING_LEFT):
		translation.x -= speed