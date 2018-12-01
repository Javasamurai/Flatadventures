extends Spatial

const LEVELS_SCENE = [
	preload("res://Scenes/Levels/Level1.tscn"),
	preload("res://Scenes/Levels/Level2.tscn"),
	preload("res://Scenes/Levels/Level3.tscn")
]

const SPRITE_BG = [
	preload("res://Assets/pngs/sky.png"),
	preload("res://Assets/pngs/scifibg.jpg"),
	preload("res://Assets/pngs/grave_BG.png")
]

var level_node
var audio_player

func _ready():
	set_up_audio()
	set_up_level()

func set_up_audio():
	audio_player = AudioStreamPlayer.new()
	self.add_child(audio_player)
	audio_player.connect("finished", self, "loopAudio")
	audio_player.stream = load("res://Assets/sounds/level" + str(GlobalConstants.CURR_LEVEL) + ".wav")
	audio_player.play()

func loopAudio():
	audio_player.seek(0)
	audio_player.play()

func _process(delta):
	$Camera.translation.x = $player_body.translation.x
	$Camera.translation.y = $player_body.translation.y + 2
	if $Camera.translation.y <= -10:
		GlobalConstants.lives = GlobalConstants.lives - 1
		get_tree().change_scene("res://Scenes/lives.tscn")

func set_up_level():
	for i in range(0, $CurrentLevel.get_child_count()):
		$CurrentLevel.remove_child($CurrentLevel.get_child($CurrentLevel.get_child_count() - 1))
	level_node = LEVELS_SCENE[GlobalConstants.CURR_LEVEL - 1].instance()
	$CurrentLevel.add_child(level_node)

	$player_body/bg.set_texture(SPRITE_BG[GlobalConstants.CURR_LEVEL - 1]);
