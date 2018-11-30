extends Control

var dialogues
var dialogue_pos = 0
func _ready():
	GlobalConstants.paused = true
	var file = File.new()
	file.open("res://Assets/dialogues.json", file.READ)
	dialogues = parse_json(file.get_as_text()).values()
	$ColorRect/Label.text = (dialogues[GlobalConstants.CURR_LEVEL - 1].values())[dialogue_pos]
	$ColorRect/Sprite.texture = load("res://Assets/pngs/girl_head.png" if GlobalConstants.SELECTED_PLAYER == GlobalConstants.NINJA_BOY else "res://Assets/pngs/boy_head.png")
	
func _process(delta):
	if Input.is_action_just_released('next'):
		print(dialogue_pos)
		if dialogue_pos >= dialogues[GlobalConstants.CURR_LEVEL - 1].size() - 1:
			GlobalConstants.paused = false
			$ColorRect.visible = false
			return
		dialogue_pos = dialogue_pos + 1
		$ColorRect/Label.text = (dialogues[GlobalConstants.CURR_LEVEL - 1].values())[dialogue_pos]
	pass
