extends RichTextLabel

const FORMAT_STRING: String = "[p align=c][color=ffffffaa][font_size=64][lb]Level %d[rb][/font_size][/color][/p]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.level_started.connect(_on_level_started)
	pass # Replace with function body.

func _on_level_started(level_num: int) -> void:
	text = FORMAT_STRING % level_num
